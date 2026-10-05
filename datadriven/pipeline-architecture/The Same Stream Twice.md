# The Same Stream Twice

- **Domain:** pipeline_architecture
- **Difficulty:** Hard
- **Est. time:** 30 min
- **URL:** https://datadriven.io/problems/the_same_stream_twice

## Problem

A global streaming-video platform collects about 2 billion playback heartbeat events a day from 150 million subscribers, and two teams read the same feed: reliability needs rebuffering spikes per title and region detected within seconds and pushed straight to an on-call paging tool, while finance pays studios royalties on exact minutes-watched and cannot tolerate a single double-counted or dropped event. Design the pipeline so both teams consume the same durable ingest independently, with the live path detecting spikes fast and paging on-call while the daily royalty report counts each raw event exactly once instead of reusing the live aggregation. Keep a malformed heartbeat from a bad device build from stalling the live path.

**Concepts tested:** `paBatchProcessing`, `paBatchVsStreaming`, `paDataQuality`, `paDeadLetterQueue`, `paDeduplication`, `paEltVsEtl`, `paEventDriven`, `paEventPlatforms`, `paFullVsIncremental`, `paIdempotency`, `paKappaArch`, `paLateData`, `paMonitoring`, `paPartitioning`, `paRetryHandling`, `paStreamProcessing`

## Requirements

- When a title starts rebuffering in a region, I need on-call paged within seconds, not in tomorrow's report.
- We pay studios on exact minutes-watched, so the daily total cannot double-count a retried event or drop one that slipped a window.
- A buggy device firmware release once sent malformed heartbeats and took our whole pipeline down; that can never block live alerting again.
- I don't want two separate collection paths drifting apart; both teams should be reading the same source of truth, each on their own offsets.

## Must-have components

- Rebuffering spikes have to be caught within seconds, so the QoE path must be a streaming stage. Add a stream processor reading the heartbeat feed.
- On-call is paged on a per-title, per-region rebuffering spike, which is a sub-minute freshness requirement. Mark the alerting path as sub-minute.
- Both consumers read the same ingest, so the heartbeats need a durable queue at the front that lets two independent consumers replay from their own offsets. Add a message queue at ingest.
- Royalty payments are a daily report, not a live metric. Add a daily batch stage that aggregates exact minutes-watched.
- Finance reads royalty totals from a queryable store. Add a warehouse for the daily royalty report to land in.
- Detecting a rebuffering spike is not enough; the streaming detector must feed an alert destination that pages on-call. Connect the stream processor to an on-call paging node such as PagerDuty.
- The daily royalty batch must write its exact-count output into the warehouse finance queries. Connect the batch stage to the warehouse.

**Expected stages:** `Playback heartbeat ingest` → `Live QoE stream processor` → `Rebuffering alert path` → `Dead-letter quarantine` → `Daily royalty batch` → `Royalty warehouse`

## Solution walkthrough


### Why this problem exists in real interviews

This is two consumers with opposite correctness budgets reading one event stream, disguised as a streaming dashboard. Reliability wants approximate-and-instant: a rebuffering spike per title and region in seconds, off-by-a-few is fine. Finance wants exact-and-patient: royalties on minutes-watched, where one double-counted retry is a contract dispute. The trap is the single aggregation serving both: too rough to bill on, and once you bolt exactness onto it, too slow to page on-call.

The whiteboard answer is one stream writing a `minutes_watched` table both the QoE dashboard and the royalty report read. It looks clean for a week. Then a producer retries during a deploy, both counts inflate, and finance overpays a studio. Or a malformed heartbeat crashes the consumer, it replays the same offset, and reliability goes blind for hours. Three requirements failed quietly because they were never separated.

> **Two budgets, one stream, never one aggregation**
>
> One durable ingest, then two paths sized for two budgets. The live QoE path is streaming and approximate: detect per-title, per-region rebuffering in seconds and page on-call. The royalty path is a daily batch reading the same queue directly, counting exactly once, deduped on a stable `event_id`, never reusing the live aggregation. Both read the queue from their own offsets, and bad events go to a dead-letter quarantine so the live path never stalls.

---

### Walk the requirements

**Step 1: Land everything in one durable queue**

Heartbeats land in a partitioned message queue first. The stream processor and the daily batch each read from their own committed offsets, so neither starves the other and either can replay alone. The subtle failure is chaining the royalty batch off the stream processor's output instead of the raw queue: royalties then inherit the live path's approximations and lose independent replay. Two separate collection paths drift just as badly, and the day they disagree nobody can say which number is right.

**Step 2: Stream the QoE path; approximate is the budget**

A stream processor windows heartbeats by title and region, flags rebuffering above a baseline, and emits to an alert destination inside `< 1min`. Counting a viewer mid-transition slightly wrong is fine; live-feel is the budget. The 'compute it exactly before we alert' version is where on-call learns of the incident from Twitter.

**Step 3: Make royalty exactly-once at the sink, not in the stream**

The daily batch reads raw heartbeats straight from the queue, where each event carries a stable `event_id` from the player. It dedups on that id and writes idempotently to the warehouse, so a producer retry is absorbed and a window-edge event is not dropped. Exactly-once is enforced at the sink with a key, not hoped for in the streaming layer. Billing from the approximate live table is the mistake that becomes an overpayment.

**Step 4: Quarantine poison pills, keep draining**

Validation lives on the consumer: a heartbeat that fails schema (the missing `title_id` from the bad firmware build) routes to a dead-letter quarantine and its offset is acked, so the main path keeps moving. A separate process triages the quarantine, and its depth is alerted on so a firmware regression is visible. If a bad event can halt the consumer, one device build blinds reliability during the incident it most needed to see.

---

### The shape that fits

```mermaid
flowchart LR
    Playback heartbeat ingest["Playback heartbeat ingest<br/>Kafka"]
    Live QoE stream processor["Live QoE stream processor<br/>Flink"]
    Rebuffering alert path["Rebuffering alert path<br/>PagerDuty"]
    Dead-letter quarantine["Dead-letter quarantine<br/>S3"]
    Daily royalty batch["Daily royalty batch<br/>Airflow"]
    Royalty warehouse["Royalty warehouse<br/>Snowflake"]
    Finance royalty report["Finance royalty report<br/>Tableau"]
    Playback heartbeat ingest --> Live QoE stream processor
    Playback heartbeat ingest --> Daily royalty batch
    Live QoE stream processor --> Rebuffering alert path
    Live QoE stream processor --> Dead-letter quarantine
    Daily royalty batch --> Royalty warehouse
    Royalty warehouse --> Finance royalty report
```

| node | type | tech | details |
|---|---|---|---|
| Playback heartbeat ingest | source | Kafka |  |
| Live QoE stream processor | transform | Flink | sla_freshness: < 1min |
| Rebuffering alert path | consumer | PagerDuty | sla_freshness: < 1min |
| Dead-letter quarantine | storage | S3 |  |
| Daily royalty batch | transform | Airflow | sla_freshness: < 24h |
| Royalty warehouse | storage | Snowflake | sla_freshness: < 24h |
| Finance royalty report | consumer | Tableau |  |

> **The live path is the cost center; keep royalties cheap**
>
> At 2B events/day with 5x tentpole spikes, the live path is the cost center: it must keep up in real time, so partition the queue on a high-cardinality key and autoscale the stream processor on consumer lag. The royalty batch is cheap and decoupled, running once a day off its own offsets, so an evening spike never competes with finance's close. Streaming everything would multiply compute for no gain on batch-appropriate metrics.

> **Naming the per-consumer correctness budget**
>
> The tell of seniority is naming the per-consumer correctness budget out loud: approximate-and-live for QoE, exactly-once for royalties, and refusing to bill from the live aggregation. The second tell is wiring the royalty batch to the raw queue, not the stream processor's output. Strong candidates raise the dead-letter path unprompted and ask about late heartbeats at the daily close.

> **Royalties reading the stream's output, not the queue**
>
> Chaining the royalty batch off the stream processor instead of the raw queue, so royalties silently inherit the live approximations and lose replay. The cousin mistake is streaming everything because real-time feels safer, then bolting dedup onto the live table: it drags the live path below the paging SLA and still under-counts at window edges. The third is no dead-letter path, so the first malformed firmware heartbeat halts the consumer mid-incident.

---

- **A heartbeat arrives two hours after its day already closed in the royalty warehouse. What does the batch do with it?**
  - _Tests bounded-lateness handling plus an `event_id`-keyed correction run that lands the late event in the next cycle without double-counting._
- **A tentpole release pushes the live path to 5x volume and consumer lag climbs. What keeps on-call from going blind?**
  - _Tests partitioning, autoscaling on lag, and the decoupling that stops the royalty batch from stealing the live path's resources._
