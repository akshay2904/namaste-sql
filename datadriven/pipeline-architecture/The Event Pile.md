# The Event Pile
_600 million clicks a day. The budget is not infinite._

- **Domain:** pipeline_architecture
- **Difficulty:** Hard
- **Est. time:** 25 min
- **URL:** https://datadriven.io/problems/the_event_pile

## Problem

We run a product that emits hundreds of millions of user interaction events a day into Kafka, and right now they just pile up with no good way to query them. Three groups depend on this data: analysts run funnel studies that scan months of events by type, customer support has to pull up a single user's full session while the customer is still on the phone, and product teams watch dashboards that aggregate the last hour. Every event has to stay queryable for two years and the storage bill is already too high, so design an architecture that serves all three access patterns without keeping the whole history on expensive always-on storage.

**Concepts tested:** `paBatchProcessing`, `paBatchVsStreaming`, `paColumnarVsRow`, `paCompression`, `paDagOrchestration`, `paDataLake`, `paEventDriven`, `paEventPlatforms`, `paIdempotency`, `paLateData`, `paMicroBatchVsTrue`, `paMonitoring`, `paPartitioning`, `paRetryHandling`, `paSchemaEvolution`, `paSmallFiles`, `paStreamProcessing`, `paTableFormats`

## Requirements

- The VP of Engineering wants the bill to come down without losing the two years of history we keep.
- Customer support pulls up a user's session while the customer is on the phone; today it takes minutes and customers hang up.
- Funnel analysts scan months by event type, support fetches one session, and dashboards aggregate the last hour; one storage shape can't serve all three.
- Data older than 90 days is queried rarely, but when audit or trend reports need it, the team has to be able to retrieve it.

## Must-have components

- Hundreds of millions of events per day at two-year retention can't live entirely on hot storage at the cost the business will accept. Without a cold-storage / archive tier (S3/GCS/ADLS or Iceberg/Delta/Hudi), older data has nowhere cheap to live.
- Real-time dashboards aggregate the last hour while support pulls a single session and funnel analysts scan months. One storage shape can't satisfy all three. Show at least one streaming/serving path and at least one batch / archive path.

**Expected stages:** `kafka_ingest` → `event_lake` → `session_store` → `hourly_aggregates` → `query_engine`

## Solution walkthrough


### The trap

This is a cost problem wearing a query problem's clothes. Three readers want three different physical layouts. Analysts scan months by event type. Support fetches one session by key. Dashboards roll up the last hour. Anyone can land Kafka into a warehouse; **the trap is pretending one layout serves all three**. Partition by date and support's single-session lookup scans the wrong axis while the customer hangs up. Put everything on hot, always-on storage and two years of history sits on the most expensive tier, which is exactly the bill the VP is complaining about.

> **One stream, three layouts**
>
> Fan the same Kafka topic out to three stores, each laid out for one access path. No store reads from another. Each layout can then change on its own, and any store can be rebuilt by replaying Kafka or the lake.

### Walk the requirements

**Step 1: Make the lake the source of truth**

Store the events as Parquet files in an Iceberg table on object storage, partitioned by date and event type. Two years of history live here at object-storage prices. The query engine bills per byte scanned, so a funnel over one event type skips every other partition. Write in batches every few minutes so the lake gets a few large files instead of millions of tiny ones.

**Step 2: Key the session store by user, not by date**

Support's lookup is a point read. A Flink job writes events into Redis keyed on user and session, with a TTL of a few days. The phone call becomes one key fetch that returns in milliseconds, not a scan over partitions.

**Step 3: Pre-aggregate the last hour on the stream**

Dashboards never need raw rows. Flink rolls events into per-minute counts by event type and writes those small rows to the dashboard store. A heavy analyst scan on the lake can then never slow a dashboard down.

**Step 4: Keep old data online, not archived**

Data older than 90 days stays in the same Iceberg table. A lifecycle rule can move older partitions to an infrequent-access storage class that is still readable in milliseconds. Audits run the same SQL over more bytes. Deep archive that needs a restore of several hours breaks the one-hour retrieval requirement.

### The reference design

```mermaid
flowchart LR
    kafka events["kafka events<br/>Kafka"]
    lake writer["lake writer<br/>Spark"]
    event lake["event lake<br/>Iceberg"]
    session writer["session writer<br/>Flink"]
    session store["session store<br/>Redis"]
    dashboard aggregator["dashboard aggregator<br/>Flink"]
    dashboard store["dashboard store<br/>Snowflake"]
    serverless query["serverless query<br/>SQL"]
    support console["support console<br/>API"]
    analyst queries["analyst queries<br/>Tableau"]
    product dashboards["product dashboards<br/>Grafana"]
    kafka events --> lake writer
    kafka events --> session writer
    kafka events --> dashboard aggregator
    lake writer --> event lake
    session writer --> session store
    dashboard aggregator --> dashboard store
    event lake --> serverless query
    session store --> support console
    dashboard store --> product dashboards
    serverless query --> analyst queries
```

| node | type | tech | details |
|---|---|---|---|
| kafka events | source | Kafka |  |
| lake writer | transform | Spark | slaFreshness: < 15min |
| event lake | storage | Iceberg |  |
| session writer | transform | Flink | slaFreshness: real-time |
| session store | storage | Redis | slaFreshness: < 1min |
| dashboard aggregator | transform | Flink | slaFreshness: real-time |
| dashboard store | storage | Snowflake | slaFreshness: real-time |
| serverless query | transform | SQL | slaFreshness: < 1h |
| support console | consumer | API | slaFreshness: < 1min |
| analyst queries | consumer | Tableau | slaFreshness: < 1h |
| product dashboards | consumer | Grafana | slaFreshness: real-time |

| One warehouse for everything | Three stores from one stream |
|---|---|
| Two years sit on always-on warehouse storage. Support's lookup scans date partitions. An analyst's scan of last quarter competes with the dashboards for the same compute. Teams patch it with materialized views, and the bill keeps rising. | Most bytes sit in the lake at object-storage prices. Support reads one key, dashboards read precomputed rollups, and analysts pay per byte scanned. There are more moving parts, but a failure in one store stays in that store. |

> **Feeding one store from another**
>
> Candidates often draw the session store or the dashboards reading from the lake. That puts a batch hop on a path that has to answer in under a second, and it ties the two stores' failures together. Every store reads Kafka directly.

> **Bound the hot store out loud**
>
> Strong candidates put a limit on the Redis footprint: recent sessions only, with a TTL. They also say where a year-old session comes from instead, which is the lake. That one sentence shows they priced the design.

- **Support asks for a session from a year ago. What changes?**
  - _Tests whether you keep the hot store small and serve the long tail from the lake, with files sorted by user inside each date partition so the lookup stays a short scan._
- **A client sends every event twice. Which store cares?**
  - _Tests dedup on a stable event id before the fan-out. Dashboard counts double, and the lake writer needs an idempotent upsert._
