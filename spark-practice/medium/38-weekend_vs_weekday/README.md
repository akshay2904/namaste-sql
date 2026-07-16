# 38. Weekend vs Weekday Revenue

**Difficulty:** medium  
**Tags:** date functions, case when  
**Source:** https://spark.vutrinh.net/problems/weekend_vs_weekday

## Problem

Given a table `sales` with columns `sale_id`, `sale_date`, and `amount`, compare total revenue on **weekends vs weekdays**.

A day is a **Weekend** if it falls on Saturday or Sunday, otherwise it is a **Weekday**.

Return columns: `day_type` (either `'Weekend'` or `'Weekday'`), `total_revenue`, `num_sales`

Order by `day_type` ascending (alphabetical).

> Hint: In Spark, `DAYOFWEEK` returns `1` for Sunday and `7` for Saturday.

## Schema

**`sales`**

| column | type |
|---|---|
| sale_id | INT |
| sale_date | STRING |
| amount | INT |

## Sample Input

**`sales`**

| sale_id | sale_date | amount |
|---|---|---|
| 1 | 2024-01-01 | 120 |
| 2 | 2024-01-02 | 85 |
| 3 | 2024-01-03 | 200 |
| 4 | 2024-01-04 | 150 |
| 5 | 2024-01-05 | 95 |

## Hints

<details><summary>Hint 1</summary>

You need to classify each sale as a weekend or weekday based on the day of the week of its `sale_date`. Spark's `DAYOFWEEK` function returns an integer: `1` = Sunday, `2` = Monday, ..., `7` = Saturday. Use a `CASE WHEN` expression to map those values to `'Weekend'` or `'Weekday'`, then aggregate.

</details>

<details><summary>Hint 2</summary>

1. Use `DAYOFWEEK(sale_date)` to get the numeric day of the week.
2. Wrap it in a `CASE WHEN` to produce `'Weekend'` when the result is `1` (Sunday) or `7` (Saturday), and `'Weekday'` otherwise.
3. Group by the resulting `day_type` column.
4. Aggregate with `SUM(amount)` and `COUNT(*)`.
5. Order by `day_type` ascending.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT
  CASE WHEN DAYOFWEEK(sale_date) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
  SUM(amount) AS total_revenue,
  COUNT(*) AS num_sales
FROM sales
GROUP BY day_type
ORDER BY day_type
```

</details>

## Solutions

### SQL

```sql
SELECT
  CASE WHEN DAYOFWEEK(sale_date) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
  SUM(amount) AS total_revenue,
  COUNT(*) AS num_sales
FROM sales
GROUP BY CASE WHEN DAYOFWEEK(sale_date) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END
ORDER BY day_type
```

**Why it works:**
- `DAYOFWEEK` returns 1 for Sunday and 7 for Saturday in Spark SQL
- The `CASE WHEN ... IN (1, 7)` expression captures both weekend days in a single condition
- `GROUP BY` on the expression collapses all sales into two buckets
- `SUM` and `COUNT` compute the totals for each bucket

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .withColumn(
        "day_type",
        F.when(F.dayofweek(F.col("sale_date")).isin(1, 7), "Weekend").otherwise("Weekday")
    )
    .groupBy("day_type")
    .agg(
        F.sum("amount").alias("total_revenue"),
        F.count("*").alias("num_sales")
    )
    .orderBy("day_type")
)
```

**Why it works:**
- `F.dayofweek(...)` returns 1 (Sunday) through 7 (Saturday)
- `.isin(1, 7)` matches both weekend days in a concise expression
- `F.when(...).otherwise(...)` is the DataFrame equivalent of `CASE WHEN`
- `.groupBy` and `.agg` compute the revenue and count per bucket
