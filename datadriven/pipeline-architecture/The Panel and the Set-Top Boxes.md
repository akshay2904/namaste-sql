# The Panel and the Set-Top Boxes
_Set-top boxes tell you who watched. Projection tells you how many._

- **Domain:** pipeline_architecture
- **Difficulty:** Hard
- **Est. time:** 10 min
- **URL:** https://datadriven.io/problems/the_panel_and_the_set_top_boxes

## Problem

An on-call engineer watched one cable operator's late file and one show's crashed projection hold every network past its 8am early ratings read and every client past the 10am final ratings. We project national TV audiences by weighting a 40,000-household viewing panel against set-top box data from 45 million devices, which the cable operators deliver overnight, each on its own schedule. Design the pipeline so the early read ships on whatever has arrived, a failed show holds up only itself, the final picks up the stragglers, and a late or restated operator file produces a revised report kept on record beside the original, with the affected clients told what changed.

**Concepts tested:** `paBatchProcessing`, `paDagOrchestration`, `paDataQuality`, `paFullVsIncremental`, `paIdempotency`, `paLateData`, `paMonitoring`, `paPartitioning`, `paRetryHandling`

## Requirements

- Networks make same-day programming decisions on the early ratings and final ratings are due to all clients by mid-morning; missing the deadline triggers contractual penalties.
- Cable operators deliver on different schedules and one late operator can't block national ratings for everyone else.
- When a cable operator delivers late or revises a prior period, ratings have to be re-run and clients told about the revision; silent changes are a regulatory and contractual problem.
- When the projection job for one show fails, the other shows still have to deliver; one giant job for everything has caused mass delivery delays.

## Must-have components

- The 8am preliminary and 10am final delivery deadlines, late-operator handling, per-show isolation, and revisions all need a scheduler that runs and monitors them. Add Airflow, Dagster, or Prefect.

**Expected stages:** `viewing_events_raw` → `panel_weights` → `projected_ratings` → `client_delivery_log`

## Solution walkthrough


### What this really is

This is a deadline-bound batch DAG in a TV-ratings costume. Weighting 40,000 panel homes against 45 million set-top boxes is the easy part. The hard part is the shape of the work. The trap is **one nightly job keyed on the calendar day**. It waits for the slowest cable operator, so every network misses its early read. It dies on one broken show, so every client misses 10am. When an operator restates last Tuesday, it quietly overwrites numbers clients have already traded on.

> **Partition by operator going in, by show coming out**
>
> Ingest is fanned out per operator, so lateness has a name. Projection is fanned out per show, so a failure has a blast radius of one. Revisions are new versions, never updates. Every requirement in the prompt falls out of those three cuts.

### Build it in order

**Step 1: Land and validate each operator separately**

Each operator's file lands into `viewing_events_raw` as its own task, behind a validation gate that checks row counts and device coverage against that operator's history. A late operator is a sensor that times out and pages with the operator's name. The national run proceeds without it and flags the affected markets.

**Step 2: Schedule against two deadlines, not one**

Networks make same-day programming calls on an early read, so the orchestrator runs projection twice. The 8am preliminary uses whatever operators have arrived. The 10am final adds the stragglers. Both deadlines are SLAs the orchestrator monitors, so a miss alerts before the client notices.

**Step 3: Give every show its own projection task**

Apply `panel_weights` per show and write `projected_ratings` through a staging table, then swap it in. Each task retries on its own, and a rerun replaces its partition instead of appending duplicates. A model blowup on one sitcom stays one red task while the other shows deliver.

**Step 4: Turn late or corrected data into a versioned revision**

Late or restated operator files flow from ingest into the revision processor. It re-projects only the affected shows and periods, then writes a new version keyed by period, show and revision number into the archive next to the original. It also emits a revision notice to the affected clients and logs both in `client_delivery_log`.

```mermaid
flowchart LR
    panel data["panel data<br/>S3"]
    set top box data["set top box data<br/>Kafka"]
    orchestrator["orchestrator<br/>Airflow"]
    per operator ingest["per operator ingest<br/>Spark"]
    operator file validation["operator file validation<br/>Great Expectations"]
    per show projection["per show projection<br/>Spark"]
    ratings warehouse["ratings warehouse<br/>Snowflake"]
    revision processor["revision processor<br/>Spark"]
    delivery archive["delivery archive<br/>S3"]
    clients["clients<br/>API"]
    revision notices["revision notices<br/>Email"]
    panel data --> per operator ingest
    set top box data --> per operator ingest
    orchestrator --> per operator ingest
    orchestrator --> per show projection
    orchestrator --> revision processor
    per operator ingest --> operator file validation
    operator file validation --> per show projection
    operator file validation --> revision processor
    per show projection --> ratings warehouse
    ratings warehouse --> delivery archive
    ratings warehouse --> revision processor
    revision processor --> ratings warehouse
    revision processor --> delivery archive
    revision processor --> revision notices
    delivery archive --> clients
```

| node | type | tech | details |
|---|---|---|---|
| panel data | source | S3 |  |
| set top box data | source | Kafka |  |
| orchestrator | transform | Airflow | errorAction: alert; monitorAlert: Operator late, or per-show projection missed 8am preliminary or 10am final |
| per operator ingest | transform | Spark | errorAction: alert |
| operator file validation | quality_gate | Great Expectations | errorAction: alert |
| per show projection | transform | Spark | retryCount: 3; errorAction: retry; parallelism: 8 partitions; idempotencyStrategy: staging_table |
| ratings warehouse | storage | Snowflake | slaFreshness: < 24h; backfillStrategy: partition_overwrite |
| revision processor | transform | Spark | idempotencyStrategy: staging_table |
| delivery archive | storage | S3 | backfillStrategy: incremental |
| clients | consumer | API | slaFreshness: < 24h |
| revision notices | consumer | Email |  |

> **A revision box with no input is decoration**
>
> Candidates draw a revision processor and wire only its output. Ask what triggers it and the design has no answer. The late or corrected operator file has to physically reach it, and the clients have to hear about the result. Otherwise the revision requirement is a label, not a path.

| One nightly job | Per-operator, per-show DAG |
|---|---|
| Starts when the last operator lands. One bad show fails the whole run. A restatement overwrites the table in place, and clients find out from their own reconciliations. | Early read ships on what arrived. A failed show retries alone. A restatement becomes revision 2 in the archive, revision 1 stays as shipped, and a notice goes out. |

> **Name the late operator, not the late pipeline**
>
> The senior tell is alert granularity. 'Ratings delayed' wakes everyone up and helps no one. 'Operator X missed its 6am drop; 3 markets flagged in the preliminary' lets on-call act before 8am and lets account managers warn the right networks.

> **Wide DAG, small reruns**
>
> 45 million devices of second-level data is a few billion rows a night, but a revision rarely touches more than one operator's markets for a handful of shows. Partitioning by period and show means a restatement re-projects a sliver, not the whole night, and the staging-table swap makes the retry safe.

- **An operator restates a period from last week. Walk the data from file to client inbox.**
  - _Tests the full revision path: ingest, validation, scoped re-projection, a versioned archive write beside the original, and a notice to only the affected clients._
- **The 8am preliminary shipped without one operator. How do clients know which markets to trust?**
  - _Tests whether flagged markets travel with the preliminary rather than living only in an internal alert._
- **A show needs a different weighting model. What changes in the DAG?**
  - _Tests per-show tasks as the extension point: a new task, with shared ingest, warehouse and archive untouched._
