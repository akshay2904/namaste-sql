# 26. Remove Statistical Outliers

**Difficulty:** medium  
**Tags:** aggregation, statistics, percentile  
**Source:** https://spark.vutrinh.net/problems/remove_outliers

## Problem

Given a table `transactions` with columns `transaction_id` and `amount`, remove statistical outliers using the **IQR method**.

Compute Q1 = `percentile_approx(amount, 0.25)` and Q3 = `percentile_approx(amount, 0.75)`. Then IQR = Q3 - Q1. Keep only transactions where:

```
amount BETWEEN (Q1 - 1.5 * IQR) AND (Q3 + 1.5 * IQR)
```

Return columns: `transaction_id`, `amount`

Order by `transaction_id` ascending.

## Schema

**`transactions`**

| column | type |
|---|---|
| transaction_id | INT |
| amount | INT |

## Sample Input

**`transactions`**

| transaction_id | amount |
|---|---|
| 1 | 50 |
| 2 | 55 |
| 3 | 48 |
| 4 | 62 |
| 5 | 57 |

## Hints

<details><summary>Hint 1</summary>

The IQR (Interquartile Range) method defines outliers as values more than 1.5× the IQR below Q1 or above Q3. Q1 is the 25th percentile and Q3 is the 75th percentile. IQR = Q3 - Q1.

</details>

<details><summary>Hint 2</summary>

Use `percentile_approx(amount, 0.25)` for Q1 and `percentile_approx(amount, 0.75)` for Q3 in a CTE or subquery to get the bounds, then join or cross join back to the original table to filter rows.

</details>

<details><summary>Hint 3</summary>

```sql
WITH stats AS (
    SELECT
        percentile_approx(amount, 0.25) AS q1,
        percentile_approx(amount, 0.75) AS q3
    FROM transactions
)
SELECT t.transaction_id, t.amount
FROM transactions t
CROSS JOIN stats
WHERE t.amount BETWEEN (q1 - 1.5 * (q3 - q1)) AND (q3 + 1.5 * (q3 - q1))
ORDER BY t.transaction_id
```

</details>

## Solutions

### SQL

```sql
WITH stats AS (
    SELECT
        percentile_approx(amount, 0.25) AS q1,
        percentile_approx(amount, 0.75) AS q3
    FROM transactions
)
SELECT t.transaction_id, t.amount
FROM transactions t
CROSS JOIN stats
WHERE t.amount BETWEEN (q1 - 1.5 * (q3 - q1)) AND (q3 + 1.5 * (q3 - q1))
ORDER BY t.transaction_id
```

**Why it works:**
- The CTE computes Q1 and Q3 across all rows once
- `CROSS JOIN stats` makes the percentile values available to every row
- The `BETWEEN` clause applies the IQR fence: lower = Q1 - 1.5*IQR, upper = Q3 + 1.5*IQR
- Rows outside the fence (outliers) are excluded

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

stats = df.agg(
    F.percentile_approx("amount", 0.25).alias("q1"),
    F.percentile_approx("amount", 0.75).alias("q3")
).collect()[0]

q1, q3 = stats["q1"], stats["q3"]
iqr = q3 - q1
lower = q1 - 1.5 * iqr
upper = q3 + 1.5 * iqr

result = (
    df
    .filter((F.col("amount") >= lower) & (F.col("amount") <= upper))
    .orderBy("transaction_id")
)
```

**Why it works:**
- `F.percentile_approx` computes approximate quantiles efficiently on large datasets
- The bounds are computed on the driver and used as scalar filter values
- The filter retains only non-outlier rows
