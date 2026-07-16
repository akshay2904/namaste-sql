# 33. Percentile Rank of Sales

**Difficulty:** hard  
**Tags:** window functions, percent_rank, ntile  
**Source:** https://spark.vutrinh.net/problems/percentile_rank

## Problem

Given a table `sales_reps` with columns `rep_id`, `name`, `region`, and `total_sales`, compute each sales rep's **percent rank** and **quartile (NTILE 4)** within their region, both ranked by `total_sales` descending.

Round `pct_rank` to 2 decimal places.

Return columns: `rep_id`, `name`, `region`, `total_sales`, `pct_rank`, `quartile`

Order by `region` ascending, then `total_sales` descending.

## Schema

**`sales_reps`**

| column | type |
|---|---|
| rep_id | INT |
| name | STRING |
| region | STRING |
| total_sales | INT |

## Sample Input

**`sales_reps`**

| rep_id | name | region | total_sales |
|---|---|---|---|
| 1 | Alice | North | 82000 |
| 2 | Bob | North | 95000 |
| 3 | Carol | North | 71000 |
| 4 | Dave | North | 110000 |
| 5 | Eve | South | 63000 |

## Hints

<details><summary>Hint 1</summary>

`PERCENT_RANK()` returns a value between 0 and 1 representing the relative position of a row within its partition: `(rank - 1) / (total_rows - 1)`. `NTILE(4)` divides the partition into 4 equal buckets (quartiles) and assigns each row to a bucket.

</details>

<details><summary>Hint 2</summary>

Both functions use the same window: `PARTITION BY region ORDER BY total_sales DESC`. Apply them in the same SELECT clause. Note that `PERCENT_RANK()` takes no arguments — the ordering is entirely determined by the window specification.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT rep_id, name, region, total_sales,
       ROUND(PERCENT_RANK() OVER (PARTITION BY region ORDER BY total_sales DESC), 2) AS pct_rank,
       NTILE(4) OVER (PARTITION BY region ORDER BY total_sales DESC) AS quartile
FROM sales_reps
ORDER BY region, total_sales DESC
```

</details>

## Solutions

### SQL

```sql
SELECT rep_id,
       name,
       region,
       total_sales,
       ROUND(PERCENT_RANK() OVER (PARTITION BY region ORDER BY total_sales DESC), 2) AS pct_rank,
       NTILE(4) OVER (PARTITION BY region ORDER BY total_sales DESC) AS quartile
FROM sales_reps
ORDER BY region, total_sales DESC
```

**Why it works:**
- Both window functions share the same partition and ordering
- `PERCENT_RANK()` gives 0.0 for the top performer and 1.0 for the lowest within each region
- `NTILE(4)` assigns quartile labels 1–4 where 1 is the top quartile
- `ROUND(..., 2)` formats the percent rank to 2 decimal places

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

w = Window.partitionBy("region").orderBy(F.col("total_sales").desc())

result = (
    df
    .withColumn("pct_rank", F.round(F.percent_rank().over(w), 2))
    .withColumn("quartile", F.ntile(4).over(w))
    .select("rep_id", "name", "region", "total_sales", "pct_rank", "quartile")
    .orderBy("region", F.col("total_sales").desc())
)
```

**Why it works:**
- `F.percent_rank()` and `F.ntile(4)` are applied over the same descending window
- Both functions require an ordered window specification
- `F.round(..., 2)` rounds the percent rank output
