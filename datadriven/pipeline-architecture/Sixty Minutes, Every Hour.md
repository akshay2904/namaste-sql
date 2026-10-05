# Sixty Minutes, Every Hour
_Every hour, on the hour. No excuses._

- **Domain:** pipeline_architecture
- **Difficulty:** Medium
- **Est. time:** 20 min
- **URL:** https://datadriven.io/problems/sixty_minutes_every_hour

## Problem

We run an OLTP database behind a customer-facing app, and the analytics team needs its data in the warehouse within an hour of every change, refreshed on the hour. Design a pipeline that pulls source changes without loading the live database, exposes each hour to consumers all at once so a dashboard never reads a half-updated hour, and can replay missed windows after an outage without dropping or double-counting rows. Deletes at the source, including GDPR erasures, must stop the record from being queryable.

**Concepts tested:** `paBackfill`, `paBatchProcessing`, `paCdc`, `paDagOrchestration`, `paDeduplication`, `paEltVsEtl`, `paFullVsIncremental`, `paIdempotency`, `paMicroBatchVsTrue`

## Requirements

- Analytics runs on the hour every hour; an event that happened in the prior hour has to be in the warehouse by the next run.
- Three dashboards run shortly after each hour; they can't see an hour where some tables have updated and others haven't.
- When the pipeline is down for hours, the rerun has to replay missed windows in order without losing rows or duplicating them.
- When a customer is deleted at the source, the warehouse can't keep showing them.

## Must-have components

- The pipeline loads from OLTP into the warehouse on an hourly cadence. Without a warehouse tier there's no target for the loads. Add Snowflake, BigQuery, Redshift, or Databricks.
- Hourly loading straight off the live OLTP means polling the production database, which is the operational risk this design avoids, and deletes still have to propagate. Capture changes off the source log and carry them on a durable stream: a CDC source feeding a Kafka or Kinesis queue.

**Expected stages:** `cdc_source` → `change_stream` → `staging_area` → `hourly_transform` → `warehouse_load`

## Solution walkthrough


### The trap

This is change data capture dressed up as a scheduling problem. "Hourly" makes everyone reach for a cron job that SELECTs the last hour and appends. That one move breaks all four requirements. It loads the production database. Dashboards read a half-written hour. A rerun double-counts what a partial run already wrote. A hard delete leaves no row to select, so the customer lives on in the warehouse. Anyone can name CDC, a swap, a checkpoint and a delete handler. What separates candidates is seeing that **they are one pattern, not four fixes**.

> **One change id ties all four together**
>
> Read the WAL or binlog, not the tables, and carry every change on a durable stream with its log position. That position is the stable id. Replay keys off it, the staging rebuild is idempotent on it, and deletes ride the same stream as events. The swap stays safe because a rerun rebuilds the same hour from the same ids.

### Walk the requirements

**Step 1: Capture off the log, never the tables**

Log-based CDC tails the log the database already writes, so the app sees zero extra query load. Polling SELECTs are the design operations rejects. Polling also cannot see a hard delete.

**Step 2: Build the hour in staging, then swap**

Each hour lands in a staging table that is a separate node from the warehouse. A quality gate checks it. Then one atomic swap publishes it: a partition overwrite, a transactional rename or a table-format commit. All three dashboards see the old hour or the new one, never a mix.

**Step 3: Replay from the retained position**

After an outage, the loader restarts from its last committed log position. The stream still holds the missed windows, so they replay in order. Writes are idempotent on the change id, and a partial run only ever touched staging. The rerun converges instead of double-counting.

**Step 4: Treat deletes as events**

A source delete becomes a DELETE event on the stream. The warehouse sets `is_deleted` and `deleted_at`, and consumers filter on `is_deleted`. A compaction job purges those rows once retention expires, so GDPR erasure completes on schedule and leaves an audit trail.

### The shape that fits

```mermaid
flowchart LR
    oltp db["oltp db<br/>PostgreSQL"]
    change data capture["change data capture<br/>CDC"]
    change event bus["change event bus<br/>Kafka"]
    orchestrator["orchestrator<br/>Airflow"]
    staging loader["staging loader<br/>Spark"]
    staging table["staging table<br/>Snowflake"]
    quality check["quality check<br/>Great Expectations"]
    warehouse swap["warehouse swap<br/>dbt"]
    analytics warehouse["analytics warehouse<br/>Snowflake"]
    analytics dashboards["analytics dashboards<br/>Tableau"]
    oltp db --> change data capture
    change data capture --> change event bus
    orchestrator --> staging loader
    change event bus --> staging loader
    staging loader --> staging table
    staging table --> quality check
    quality check --> warehouse swap
    warehouse swap --> analytics warehouse
    analytics warehouse --> analytics dashboards
```

| node | type | tech | details |
|---|---|---|---|
| oltp db | source | PostgreSQL |  |
| change data capture | source | CDC |  |
| change event bus | queue | Kafka |  |
| orchestrator | transform | Airflow |  |
| staging loader | transform | Spark |  |
| staging table | storage | Snowflake |  |
| quality check | quality_gate | Great Expectations |  |
| warehouse swap | transform | dbt |  |
| analytics warehouse | storage | Snowflake |  |
| analytics dashboards | consumer | Tableau |  |

> **Hard-deleting the warehouse row**
>
> Candidates who do propagate deletes often just DELETE the warehouse row. The customer disappears, and so does any proof the erasure happened. Soft-delete now and purge on compaction: the reviewer sees both the removal and the record of it.

> **Staging is its own box**
>
> The tell is a staging tier drawn separately from the warehouse, with a gate between them. A design that writes straight into the table the dashboards query has no answer to "what does the dashboard see at 10:02?"

> **More parts, flat source load**
>
> Load on the OLTP stays flat however many tables you replicate, because log readers do not scan. The price is a stream to operate and roughly double storage for the hour being built.

- **The pipeline is down for four hours. What do dashboards show meanwhile, and how does it catch up?**
  - _The warehouse holds the last swapped hour. On restart, the loader replays each missed hour from its log position and swaps them in order._
- **A delete arrives for a customer already soft-deleted last week. What happens?**
  - _Tests idempotency: the update is a no-op or refreshes `deleted_at`, and queries return nothing either way._
