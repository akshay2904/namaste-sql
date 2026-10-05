# Everything Lands, Then It Ships

- **Domain:** pipeline_architecture
- **Difficulty:** Medium
- **Est. time:** 30 min
- **URL:** https://datadriven.io/problems/everything_lands_then_it_ships

## Problem

We run a global beverage manufacturer, and every night roughly 900 distributors drop depletion and sell-through files into a shared bucket in whatever shape their local systems produce: CSV, semicolon-delimited exports, and the occasional spreadsheet, around 40 million rows a night with columns that drift and rename without warning. Design the batch pipeline that lands these raw files immutably, cleanses and conforms them into tables that can absorb the changing columns and be overwritten one distributor-day at a time, and publishes a trustworthy Gold layer of daily sales by distributor and product for BI the next morning. It runs on a nightly schedule that sequences the stages and lets a bad or late file from one distributor be reprocessed without corrupting the numbers everyone else already trusts.

**Concepts tested:** `paBackfill`, `paBatchProcessing`, `paDagOrchestration`, `paDataLake`, `paDataQuality`, `paDependencyMgmt`, `paFileIngestion`, `paIdempotency`, `paLateData`, `paMedallion`, `paPartitioning`, `paRetryHandling`, `paSchemaEvolution`, `paSmallFiles`

## Requirements

- When a distributor sends a corrupt file, we need to go back to exactly what they sent and reprocess it without guessing.
- Distributors rename and reorder columns constantly, and the numbers still have to line up across all of them.
- BI opens the daily sales dashboard every morning and it has to be right and complete.
- One late file at 3am shouldn't force a full re-run or corrupt the distributors that already loaded cleanly.

## Must-have components

- The files arrive on a nightly cadence, so the pipeline needs a batch ingestion tier. Add a batch processing node that picks up the day's files.
- Raw distributor files must land immutably before any transformation, so you can replay a bad file later. Add a cold-storage landing zone (the Bronze raw layer).
- The cleansed Silver and published Gold tables need a table format that supports schema evolution and atomic overwrite. Add a lakehouse tier to hold the conformed layers.
- A malformed or drifted file must be caught before it reaches Gold. Add a data-quality gate between the cleansed layer and the published aggregates.
- Something has to sequence landing, cleanse, quality, and publish each night and own the reprocessing of a single late file. Add an orchestration layer (Airflow, Dagster, or Prefect).

**Expected stages:** `Nightly orchestration (DAG scheduler)` → `Landing / raw file arrival` → `Bronze (immutable raw ingest)` → `Silver (cleansed + conformed)` → `Gold (daily sales aggregates)` → `Serving / BI`

## Solution walkthrough


### What this really is

This is a replay problem dressed up as a nightly load. Anyone can draw Bronze, Silver and Gold. The real question is **which tier is allowed to change**. Bronze is append-only and never rewritten. Silver and Gold are overwritten one distributor-day at a time. Merge those two rules and either choice hurts you. Append straight into Gold, and a resent Tuesday file doubles Tuesday. Overwrite the raw tier, and a resend erases what the distributor first sent. If that 'correction' turns out to be the corrupt file, you have nothing left to replay.

The layers do real work because of the input: about 900 uncoordinated senders, around 3,000 files a night because some split their drop, headers that drift without warning, and corrections that arrive out of order. Each tier owns exactly one of those problems.

### Four decisions, in order

**Step 1: Land every file once and never touch it again**

Bronze on S3 is partitioned by distributor and arrival date. A resend lands next to the original with its own arrival timestamp, so both versions survive. Ingest copies bytes and parses nothing, which means a renamed column can never fail it.

**Step 2: Conform the drift into one Silver schema**

Per-distributor column mappings turn CSVs, semicolon exports and spreadsheets into one table keyed on `distributor_id`, `product_id` and `business_date`. Silver reads the latest Bronze file for each distributor-day. Rows that cannot be mapped go to quarantine instead of aborting the run.

**Step 3: Gate Silver before anything reaches Gold**

Check completeness against the expected roster (did all 900 land?), confirm keys are non-null, and confirm volumes sit inside their baseline. A failing distributor is held back and alerted on. The other 899 publish on time.

**Step 4: Overwrite by partition, downstream of raw**

Silver and Gold use Delta Lake atomic overwrite to rewrite exactly one (`distributor_id`, `business_date`) slice. A staging table makes a rerun idempotent. This only works because a resend is always the distributor's complete file for that day. When a straggler arrives at 3am, Airflow reruns that one partition and leaves the rest alone.

### The reference design

```mermaid
flowchart LR
    distributor files["distributor files<br/>S3"]
    orchestrator["orchestrator<br/>Airflow"]
    bronze raw["bronze raw<br/>S3"]
    silver conform["silver conform<br/>Spark"]
    quarantine["quarantine<br/>S3"]
    silver sales["silver sales<br/>Delta Lake"]
    quality gate["quality gate<br/>Great Expectations"]
    gold sales["gold sales<br/>Delta Lake"]
    bi["bi<br/>Power BI"]
    distributor files --> orchestrator
    orchestrator --> bronze raw
    bronze raw --> silver conform
    silver conform --> quarantine
    silver conform --> silver sales
    silver sales --> quality gate
    quality gate --> gold sales
    gold sales --> bi
```

| node | type | tech | details |
|---|---|---|---|
| distributor files | source | S3 |  |
| orchestrator | transform | Airflow | monitorAlert: Missing or late distributor file vs expected roster |
| bronze raw | storage | S3 |  |
| silver conform | transform | Spark | idempotencyStrategy: staging_table |
| quarantine | storage | S3 | monitorAlert: Unmappable rows above baseline |
| silver sales | storage | Delta Lake | backfillStrategy: partition_overwrite |
| quality gate | quality_gate | Great Expectations | errorAction: alert |
| gold sales | storage | Delta Lake | slaFreshness: < 24h; backfillStrategy: partition_overwrite |
| bi | consumer | Power BI | slaFreshness: < 24h |

| Overwrite in Bronze | Append-only Bronze |
|---|---|
| A resend replaces the original file. If the resend is the broken one, the good copy is gone and you have to email the distributor and wait. | Every received file is kept. Silver chooses the latest file per distributor-day, and rolling back means pointing Silver at the earlier arrival and rerunning one partition. |

> **Ask whether a resend carries the whole day**
>
> Partition overwrite is only safe when a correction is the complete distributor-day file. If corrections were deltas, overwriting would delete the unchanged rows. Candidates who ask this before drawing `partition_overwrite` have run one of these pipelines in production.

> **One bad file must not sink 899 good ones**
>
> A common mistake is a single all-or-nothing job, where one malformed spreadsheet aborts the whole night and BI opens to yesterday's numbers. Quarantine the bad rows, hold back that one distributor, and ship everyone else.

> **The arrival window is the budget, not compute**
>
> Forty million rows is a few GB compressed, which is a small Spark job. The real constraint is time: files finish around 3am and Gold is due by 7am. The 3,000 small files are the other cost, so compact them when writing Silver and keep partition pruning on `business_date`, which keeps single-day replays cheap.

- **A corrected file for a date three weeks ago arrives after demand planning has already consumed Gold. What happens?**
  - _Tests historical replay from append-only Bronze, and whether downstream consumers are notified of the restatement._
- **Volume grows 10x and files start landing in the middle of the batch window. What changes?**
  - _Tests partition parallelism and whether ingest should be triggered by file arrival instead of the clock._
