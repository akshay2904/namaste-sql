# End of Day Is Too Late
_Every swipe tells a story._

- **Domain:** pipeline_architecture
- **Difficulty:** Medium
- **Est. time:** 20 min
- **URL:** https://datadriven.io/problems/end_of_day_is_too_late

## Problem

Our fraud and risk teams need visibility into card transactions as they happen. Right now there's no real-time view; everything is end-of-day batch. Design a data streaming pipeline.

**Concepts tested:** `paBatchVsStreaming`, `paDataQuality`, `paDeadLetterQueue`, `paEltVsEtl`, `paEventDriven`, `paEventPlatforms`, `paIdempotency`, `paLateData`, `paMonitoring`, `paPartitioning`, `paRetryHandling`, `paStreamProcessing`

## Requirements

- The fraud team needs to act on suspicious card activity while it's happening, not after a customer has been hit.
- A lost transaction means a missed fraud signal; a duplicated one inflates volume reports finance signs off on.
- We can't fail a PCI audit on what's stored in our systems.
- Bad events do come in, and one of them can't stop the thousands of valid transactions behind it.

## Must-have components

- Fraud has to act on suspicious activity as it happens; the scenario's whole point is that end-of-day batch is too slow. Add a streaming technology (Kafka Streams, Flink, Spark Streaming) or set SLA Freshness to real-time / < 1min on the processing node.
- Transactions cannot be lost, including bad ones the team needs to review later. Add a durable landing (S3, GCS, ADLS) so events that fail validation can be set aside without blocking the main path, and so the data lake retains every transaction for finance and audit.

**Expected stages:** `event_producers` → `kafka_broker` → `stream_processor` → `sink_layer` → `monitoring`

## Solution walkthrough


### What this really is

This is a latency problem with three correctness constraints hidden in the statement. Everyone draws Kafka and a stream processor. What separates candidates is whether **every hop on the path to fraud is continuous**, and whether that path is also exactly-once, PCI-clean, and immune to a poison pill. Leave one scheduled stage on that path and fraud waits for the next run. Lose one of the other three and duplicate alerts, raw card numbers in storage, or one malformed event halting the whole stream is what ships.

> **Latency is set by the slowest hop**
>
> A pipeline is only as live as its least live stage. A tokenizer running as a scheduled Spark job puts batch right back in front of the fraud team, even if everything after it is Flink. Mark each stage on the fraud path as streaming, either with a streaming engine or with a 'real-time' freshness.

### Walk the requirements

**Step 1: Keep the whole fraud path continuous**

Card authorizations arrive through an API, are tokenized by a streaming job, land on a Kafka topic, and a Flink job updates the fraud store within seconds. Both the tokenizer and the fraud processor run with 'real-time' freshness. A batch or scheduled stage anywhere upstream of the fraud dashboard brings back end of day, just in smaller chunks.

**Step 2: Tokenize before anything persists**

The PAN is swapped for a token before the first durable write, and that includes the Kafka topic. Only the tokenization service holds the mapping, so PCI scope shrinks to that one service. Masking inside the stream processor is too late: the raw PAN already sits in the topic's retention window, and the auditor will find it there.

**Step 3: Make exactly-once an end-to-end property**

Flink checkpoints its source offsets. Each sink makes a replay harmless: the fraud store upserts on `transaction_id`, and the Delta Lake table merges on it. A transactional two-phase-commit sink reaches the same outcome. Under either mechanism, a restart must neither drop a transaction (fraud misses a signal) nor double it (finance signs off on inflated volume).

**Step 4: Route poison pills aside and keep draining**

Records that fail parsing or schema checks go to a dead letter queue, and the processor commits past them. The valid traffic behind a bad event never waits. The DLQ keeps every rejected record for review, and an alert fires when it piles up faster than expected.

### The reference design

```mermaid
flowchart LR
    card authorizations["card authorizations<br/>API"]
    tokenizer["tokenizer<br/>Flink"]
    tokenized events["tokenized events<br/>Kafka"]
    fraud stream["fraud stream<br/>Flink"]
    dead letter queue["dead letter queue<br/>S3"]
    fraud store["fraud store<br/>PostgreSQL"]
    fraud dashboard["fraud dashboard<br/>Grafana"]
    event lake["event lake<br/>Delta Lake"]
    finance reporting["finance reporting<br/>Tableau"]
    pipeline alerts["pipeline alerts<br/>PagerDuty"]
    card authorizations --> tokenizer
    tokenizer --> tokenized events
    tokenized events --> fraud stream
    fraud stream --> fraud store
    fraud stream --> event lake
    fraud stream --> dead letter queue
    fraud store --> fraud dashboard
    event lake --> finance reporting
    dead letter queue --> pipeline alerts
```

| node | type | tech | details |
|---|---|---|---|
| card authorizations | source | API |  |
| tokenizer | transform | Flink | errorAction: alert; monitorAlert: Tokenization service unavailable; slaFreshness: real-time |
| tokenized events | queue | Kafka | parallelism: 16 partitions |
| fraud stream | transform | Flink | errorAction: dlq; slaFreshness: real-time |
| dead letter queue | storage | S3 | monitorAlert: DLQ depth above baseline |
| fraud store | storage | PostgreSQL | slaFreshness: real-time; idempotencyStrategy: upsert |
| fraud dashboard | consumer | Grafana | slaFreshness: real-time |
| event lake | storage | Delta Lake | backfillStrategy: partition_overwrite; idempotencyStrategy: upsert |
| finance reporting | consumer | Tableau | slaFreshness: < 24h |
| pipeline alerts | consumer | PagerDuty |  |

| The first cut | What survives review |
|---|---|
| Raw events land in Kafka, the PAN is masked inside the processor, the fraud store is append-only, and a parse error crashes the consumer. Every restart replays offsets into sinks that count them twice. | Tokens only past the edge. Checkpointed offsets plus sinks keyed on `transaction_id` make a replay harmless. Parse errors go to the DLQ and the consumer never stops. |

> **A scheduled stage hiding on the live path**
>
> Candidates label the processor Flink and call the design streaming, then draw tokenization as a Spark job with no freshness. A reviewer cannot tell that hop from a nightly run, and if it is one, the fraud team is back to end of day.

> **Name where the PAN first touches disk**
>
> Strong candidates say outright that a Kafka topic is persistent storage with a retention window, which is why tokenization goes before the queue. Weak ones treat the queue as transient and mask the PAN downstream.

> **What this design pays for**
>
> Tokenization adds a hop and a hard dependency: if the service goes down, ingestion stops and an alert fires. Keyed upserts cost an index lookup on every write. The DLQ creates triage work that someone has to own. Each cost buys one requirement the fraud team, finance or the auditor would otherwise fail.

- **An issuer starts resending transactions under the same `transaction_id` with a different amount. What protects you?**
  - _Keyed upserts absorb exact duplicates silently. A mutated duplicate needs a version or a conflict rule, not just a key._
- **One merchant floods a single Kafka partition during a sale. What happens to fraud latency?**
  - _Tests skew awareness: salting the key, or partitioning on the card token instead of the merchant._
- **Auditors want every PAN that flowed through in the last 90 days. Where do you look?**
  - _Only the tokenization service holds PANs. The lake and the fraud store hold tokens alone._
