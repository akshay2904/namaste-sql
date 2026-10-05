# A Clean Number for Every Merchant
_Raw payment logs in. Clean merchant summaries out._

- **Domain:** pipeline_architecture
- **Difficulty:** Hard
- **Est. time:** 25 min
- **URL:** https://datadriven.io/problems/a_clean_number_for_every_merchant

## Problem

Our payments platform generates a daily log containing every transaction across all merchants. The finance and BI teams need a clean merchant-level summary - total volume, transaction count, average amount - but the raw logs have duplicates, schema inconsistencies, and no restart safety. Design a batch pipeline that reliably produces this summary.

**Concepts tested:** `paBatchProcessing`, `paDagOrchestration`, `paDataLake`, `paDataQuality`, `paDeadLetterQueue`, `paDeduplication`, `paFileIngestion`, `paIdempotency`, `paMedallion`, `paPartitioning`, `paRetryHandling`, `paSchemaEvolution`

## Requirements

- Finance reconciles at 7am every morning and the merchant summary has to be ready and validated by then.
- Gateway retries deliver some events twice; merchant totals can't be inflated by those duplicates.
- Records with missing merchant or amount can't be silently dropped; finance reviews them daily.
- When something fails partway through, an operator reruns the day, and the rerun has to produce the same numbers as a clean run.

## Must-have components

- Finance reads the merchant summary every morning from the warehouse. Without a warehouse tier the summary has nowhere to land. Add Snowflake, BigQuery, Redshift, or Databricks.
- Finance reconciles at 7am and the pipeline has to be restartable without producing duplicates. Without an orchestration layer there's nothing to enforce the deadline, manage retries, or coordinate the four downstream consumers. Add Airflow, Dagster, Prefect, or Composer.

**Expected stages:** `raw_log_landing` → `schema_validation` → `dedup_layer` → `merchant_aggregation` → `summary_output`

## Solution walkthrough


### What this really is

This is an idempotency problem dressed up as a daily rollup. Anyone can draw source, Spark, warehouse, dashboard. What separates candidates is whether four requirements hold at the same time: the 7am deadline, dedup of gateway retries, a home for bad rows, and reruns that land on identical numbers. Solve them one at a time and they fight each other. Pair an append-style write with a dedup that keeps whichever copy arrived first, and the operator's rerun moves a merchant's total by a few thousand dollars. After that, finance stops trusting the warehouse.

> **Make the rerun boring**
>
> Dedup on the gateway's stable `payment_id` before any aggregation. Write the summary with **partition-overwrite keyed on the report date**, through a staging table. Do both and a rerun from any failure point replaces the day with exactly the rows a clean run would have produced.

### Walk the requirements

**Step 1: Put an orchestrator on the deadline**

Airflow owns the daily DAG and its retries, and it alerts while there is still time to act if a stage threatens 7am. Without it, finance discovers the missed window when they open the dashboard. The summary lands in Snowflake, the warehouse finance already reads.

**Step 2: Dedup on `payment_id` before aggregating**

A retried event has to collapse to one row whatever order the copies arrive in. Once copies are summed into a merchant total, you cannot take them back out.

**Step 3: Quarantine bad rows, keep the rest moving**

Rows missing merchant or amount go to a quarantine table along with the rejection reason. Valid rows flow on to aggregation. Failing the whole run over one bad row blocks finance. Dropping bad rows silently makes the totals drift away from the gateway's.

**Step 4: Overwrite the date partition through staging**

Build the day in staging, then swap it into the summary partition for that date. Whichever stage failed, rerunning the date produces the same end state.

### The reference design

```mermaid
flowchart LR
    transaction log["transaction log<br/>S3"]
    orchestrator["orchestrator<br/>Airflow"]
    dedup step["dedup step<br/>Spark"]
    row validator["row validator<br/>Spark"]
    quarantine table["quarantine table<br/>Snowflake"]
    aggregator["aggregator<br/>Spark"]
    merchant summary["merchant summary<br/>Snowflake"]
    finance team["finance team<br/>Tableau"]
    transaction log --> dedup step
    orchestrator --> dedup step
    dedup step --> row validator
    row validator --> quarantine table
    row validator --> aggregator
    aggregator --> merchant summary
    merchant summary --> finance team
    quarantine table --> finance team
```

| node | type | tech | details |
|---|---|---|---|
| transaction log | source | S3 |  |
| orchestrator | transform | Airflow | errorAction: alert; monitorAlert: Stage at risk vs 7am SLA |
| dedup step | transform | Spark | idempotencyStrategy: staging_table |
| row validator | transform | Spark | errorAction: dlq |
| quarantine table | storage | Snowflake | monitorAlert: Quarantine row count above expected baseline |
| aggregator | transform | Spark | backfillStrategy: partition_overwrite; idempotencyStrategy: staging_table |
| merchant summary | storage | Snowflake | slaFreshness: < 24h; backfillStrategy: partition_overwrite |
| finance team | consumer | Tableau | slaFreshness: < 24h |

| Append the day | Overwrite the day |
|---|---|
| A failed run leaves half a day in the summary. The rerun appends a second copy on top, and a merchant's total now depends on where the first run died. | Staging builds the full day, then replaces the date partition in one swap. Whether this is the first run or the third, the partition ends up holding the same rows. |

> **Dropping bad rows is a silent shrink**
>
> The shipped version filters out anything that fails to parse. The totals then come in a little low, nobody can say which rows went missing, and finance ends up hand-reconciling against the gateway log. A quarantine table turns that gap into a list someone can review.

> **Order of operations is the tell**
>
> Strong candidates say out loud that dedup comes before aggregation and that the write replaces the partition rather than merging into it. Candidates who bolt on a dedup step after the totals exist are announcing that their reruns will drift.

> **What this design gives up**
>
> Dedup adds a shuffle on `payment_id` over the raw log. Staging roughly doubles storage while the day is being built. Quarantine adds a triage queue that finance actually has to work through. All three are cheap compared with a number nobody trusts.

- **A merchant's total jumped today, but the merchant says volume was flat. Where do you look first?**
  - _Tests reading the pipeline's evidence in order: quarantine replays, then dedup collapse counts, then the gateway log._
- **Finance wants the summary for a date six months ago, rebuilt from the raw log. Will it match the original?**
  - _Tests whether deterministic dedup plus partition-overwrite makes any day reproducible._
