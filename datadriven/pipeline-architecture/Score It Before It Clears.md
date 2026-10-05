# Score It Before It Clears
_The fraudsters move fast. Your pipeline has to move faster._

- **Domain:** pipeline_architecture
- **Difficulty:** Hard
- **Est. time:** 25 min
- **URL:** https://datadriven.io/problems/score_it_before_it_clears

## Problem

A global card-payments platform needs to score every transaction for fraud before it clears, at roughly 10,000 transactions per second. Keep scoring decoupled from the payment gateway so a slow or unavailable scorer never blocks a payment: when no score returns in time, the platform approves the transaction and sends it for asynchronous review instead of declining it. Weeks later, chargebacks confirm which transactions were actually fraud, and those labels have to feed back into model retraining. Design the pipeline.

**Concepts tested:** `paApiIngestion`, `paBatchVsStreaming`, `paDataQuality`, `paDeadLetterQueue`, `paDeduplication`, `paEventDriven`, `paEventPlatforms`, `paFullVsIncremental`, `paIdempotency`, `paLambdaArch`, `paLateData`, `paMonitoring`, `paPartitioning`, `paRetryHandling`, `paStreamProcessing`

## Requirements

- Card transactions clear quickly and the fraud decision has to come back before the transaction clears, not after.
- If the scoring service is unavailable, the business chose to approve and review later rather than block all payments; that policy has to be implemented.
- Chargebacks confirm whether transactions were actually fraud weeks later; without that loop the model never learns from real outcomes.

## Must-have components

- Card transactions need a fraud score before they clear, with sub-100ms scoring. Add a streaming layer on the transaction path or set SLA Freshness to real-time / < 1min on the scoring node.
- Scoring has to be decoupled from the payment gateway so a slow score doesn't block the transaction and a scoring outage routes to async review. Without a queue/log tier between gateway and scoring there's nothing to decouple them. Add Kafka, Kinesis, SQS, or equivalent.

**Expected stages:** `transaction_ingestion` → `stream_processor` → `feature_store` → `model_scoring` → `decision_output`

## Solution walkthrough


### What this really is

This is a deadline contract between two services that must never share a failure, dressed up as fraud detection. Anyone can draw a model behind an API. What separates candidates is who owns the clock. If the gateway calls the scorer synchronously, the scorer's worst day becomes the payment platform's worst day. At 10,000 transactions per second, a two-second stall queues 20,000 hung authorizations. The second trap is quieter: no chargeback loop. The model then retrains on its own guesses and stops getting better.

> **The gateway owns the deadline, not the scorer**
>
> The gateway publishes the transaction and starts a timer. A score that arrives in time decides. A missing score triggers **approve and route to review**, and the gateway does that itself. A dead scorer cannot block a payment because nothing waits on it past the deadline.

### Walk the requirements

**Step 1: Put a log between gateway and scorer**

Kafka absorbs the 10k/s firehose, partitioned by card so per-card velocity features stay on one Flink task. Flink reads, enriches from the feature store, scores, and returns a decision inside the authorization budget. The queue is what lets the two sides fail independently.

**Step 2: Make the fallback a path you can point to**

Draw the deadline miss as an error path from the gateway to a review queue. The business chose approve-and-review. On the canvas that choice is a visible edge with a destination, not a timeout someone added during an incident.

**Step 3: Join predictions to chargebacks before retraining**

The scorer writes every decision to the labels store keyed by transaction id. Chargebacks land weeks later against the same key. Retraining reads that join, so it learns from confirmed fraud, and the new model ships back to the scorer.

```mermaid
flowchart LR
    payment gateway["payment gateway<br/>API"]
    transaction stream["transaction stream<br/>Kafka"]
    fraud scorer["fraud scorer<br/>Flink"]
    feature store["feature store<br/>Feast"]
    authorization decision["authorization decision<br/>API"]
    review queue["review queue<br/>SQS"]
    review console["review console<br/>API"]
    chargeback feed["chargeback feed<br/>API"]
    labels store["labels store<br/>Snowflake"]
    retraining job["retraining job<br/>Spark"]
    payment gateway --> transaction stream
    transaction stream --> fraud scorer
    feature store --> fraud scorer
    fraud scorer --> authorization decision
    payment gateway --> review queue
    review queue --> review console
    fraud scorer --> labels store
    chargeback feed --> labels store
    labels store --> retraining job
    retraining job --> fraud scorer
```

| node | type | tech | details |
|---|---|---|---|
| payment gateway | source | API |  |
| transaction stream | queue | Kafka |  |
| fraud scorer | transform | Flink |  |
| feature store | storage | Feast |  |
| authorization decision | consumer | API |  |
| review queue | queue | SQS |  |
| review console | consumer | API |  |
| chargeback feed | source | API |  |
| labels store | storage | Snowflake |  |
| retraining job | transform | Spark |  |

| Synchronous call | Queue plus deadline |
|---|---|
| Gateway blocks on the scorer. A slow model means slow payments, and an outage means either declines or an improvised approve-on-error. | Gateway publishes and waits only up to its budget. A scorer outage costs fraud coverage for a while and never costs availability. |

> **Hanging the fallback off the scorer**
>
> Candidates often draw the review path coming out of the scorer. When the scorer is down, it emits nothing, so that path is dead exactly when you need it. The fallback has to start at the side that is still alive: the gateway.

> **Late scores still get recorded**
>
> Strong candidates say what happens to a score that arrives after the deadline. The gateway has already approved, and the late score does not reverse that. It is still logged with its timing, so retraining sees both the score and the action the gateway actually took.

- **A chargeback is reversed after dispute. How does the labels store reflect it?**
  - _Labels as latest-state per transaction id, so retraining never reads stale fraud labels._
- **Kafka redelivers a transaction after a scorer restart. What stops a double decision?**
  - _Idempotent writes keyed by transaction id and Flink exactly-once checkpoints._
