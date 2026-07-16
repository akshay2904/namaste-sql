# 62. ETL Job Statistics

**Difficulty:** hard  
**Tags:** window functions, aggregation, analytics  
**Source:** https://spark.vutrinh.net/problems/etl_job_stats

## Problem

Given a table `etl_jobs` with columns `job_id`, `job_name`, `pipeline`, `start_time`, `end_time`, `status`, and `rows_processed`, compute summary statistics for each pipeline.

For each pipeline calculate:
- `total_runs` — total number of job runs
- `success_rate` — percentage of successful runs, rounded to 2 decimal places
- `avg_duration_seconds` — average job duration in seconds, rounded to 2 decimal places
- `avg_rows_processed` — average rows processed per run, rounded to 2 decimal places
- `rank` — pipeline ranked by `success_rate` descending (use DENSE_RANK)

Return columns: `pipeline`, `total_runs`, `success_rate`, `avg_duration_seconds`, `avg_rows_processed`, `rank`.

Order by `rank` ascending.

## Schema

**`etl_jobs`**

| column | type |
|---|---|
| job_id | INT |
| job_name | STRING |
| pipeline | STRING |
| start_time | STRING |
| end_time | STRING |
| status | STRING |
| rows_processed | INT |

## Sample Input

**`etl_jobs`**

| job_id | job_name | pipeline | start_time | end_time | status | rows_processed |
|---|---|---|---|---|---|---|
| 1 | ingest_customers | pipeline_a | 2024-01-01 08:00:00 | 2024-01-01 08:05:30 | success | 10000 |
| 2 | transform_orders | pipeline_a | 2024-01-01 09:00:00 | 2024-01-01 09:12:00 | success | 25000 |
| 3 | load_warehouse | pipeline_a | 2024-01-01 10:00:00 | 2024-01-01 10:03:00 | failed | 0 |
| 4 | ingest_products | pipeline_b | 2024-01-02 08:00:00 | 2024-01-02 08:02:45 | success | 5000 |
| 5 | transform_inventory | pipeline_b | 2024-01-02 09:00:00 | 2024-01-02 09:08:20 | success | 12000 |

## Hints

<details><summary>Hint 1</summary>

Operational analytics on ETL pipelines requires computing aggregate health metrics per pipeline: how often they run, how often they succeed, and how long they take. Ranking pipelines by their success rate lets engineers prioritize which pipelines need attention. Duration in seconds is computed by subtracting UNIX timestamps — a portable approach that handles string-formatted timestamps.

</details>

<details><summary>Hint 2</summary>

1. Compute duration in seconds: `UNIX_TIMESTAMP(end_time) - UNIX_TIMESTAMP(start_time)`.
2. Compute `success_rate` as `ROUND(SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)`.
3. Use `ROUND(AVG(duration_seconds), 2)` and `ROUND(AVG(rows_processed), 2)` for the average metrics.
4. Apply `DENSE_RANK() OVER (ORDER BY success_rate DESC)` to rank pipelines.
5. Order the final result by `rank` ascending.

</details>

<details><summary>Hint 3</summary>

```sql
WITH pipeline_stats AS (
    SELECT
        pipeline,
        COUNT(*) AS total_runs,
        ROUND(SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS success_rate,
        ROUND(AVG(UNIX_TIMESTAMP(end_time) - UNIX_TIMESTAMP(start_time)), 2) AS avg_duration_seconds,
        ROUND(AVG(rows_processed), 2) AS avg_rows_processed
    FROM etl_jobs
    GROUP BY pipeline
)
SELECT
    pipeline,
    total_runs,
    success_rate,
    avg_duration_seconds,
    avg_rows_processed,
    DENSE_RANK() OVER (ORDER BY success_rate DESC) AS rank
FROM pipeline_stats
ORDER BY rank
```

</details>

## Solutions

### SQL

```sql
WITH pipeline_stats AS (
    SELECT
        pipeline,
        COUNT(*) AS total_runs,
        ROUND(SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS success_rate,
        ROUND(AVG(UNIX_TIMESTAMP(end_time) - UNIX_TIMESTAMP(start_time)), 2) AS avg_duration_seconds,
        ROUND(AVG(rows_processed), 2) AS avg_rows_processed
    FROM etl_jobs
    GROUP BY pipeline
)
SELECT
    pipeline,
    total_runs,
    success_rate,
    avg_duration_seconds,
    avg_rows_processed,
    DENSE_RANK() OVER (ORDER BY success_rate DESC) AS rank
FROM pipeline_stats
ORDER BY rank
```

**Why it works:**
- `UNIX_TIMESTAMP(end_time) - UNIX_TIMESTAMP(start_time)` converts timestamp strings to seconds and takes the difference
- The `CASE WHEN` expression turns status into a 0/1 flag; multiplying by 100.0 and dividing by COUNT gives the percentage
- `DENSE_RANK() OVER (ORDER BY success_rate DESC)` assigns rank 1 to the pipeline with the highest success rate; ties get the same rank
- The CTE separates aggregation from ranking, keeping the query readable

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

agg_df = (
    df
    .withColumn(
        "duration_seconds",
        F.unix_timestamp(F.col("end_time")) - F.unix_timestamp(F.col("start_time"))
    )
    .groupBy("pipeline")
    .agg(
        F.count("job_id").alias("total_runs"),
        F.round(
            F.sum(F.when(F.col("status") == "success", 1).otherwise(0)) * 100.0 / F.count("job_id"),
            2
        ).alias("success_rate"),
        F.round(F.avg("duration_seconds"), 2).alias("avg_duration_seconds"),
        F.round(F.avg("rows_processed"), 2).alias("avg_rows_processed"),
    )
)

w = Window.orderBy(F.col("success_rate").desc())

result = (
    agg_df
    .withColumn("rank", F.dense_rank().over(w))
    .select("pipeline", "total_runs", "success_rate", "avg_duration_seconds", "avg_rows_processed", "rank")
    .orderBy("rank")
)
```

**Why it works:**
- `F.unix_timestamp` converts a timestamp string to epoch seconds; subtraction gives duration
- `F.when(...).otherwise(0)` is the DataFrame equivalent of `CASE WHEN`
- `F.dense_rank().over(w)` applies dense ranking over the unpartitioned window ordered by success rate descending
- The intermediate `agg_df` is computed first so the window function can reference the already-aggregated `success_rate` column
