# 1. Group By Basics

**Difficulty:** easy  
**Tags:** aggregation, groupby  
**Source:** https://spark.vutrinh.net/problems/group_by_basics

## Problem

Given a table `data` with columns `customer_id` and `amount`, return the **total amount per customer**, ordered by `customer_id` ascending.

**Expected columns:** `customer_id`, `total_amount`

## Schema

**`data`**

| column | type |
|---|---|
| customer_id | INT |
| amount | INT |

## Sample Input

**`data`**

| customer_id | amount |
|---|---|
| 1 | 100 |
| 2 | 200 |
| 1 | 150 |
| 3 | 300 |
| 2 | 50 |

## Hints

<details><summary>Hint 1</summary>

Think about how you can **collapse multiple rows into one** based on a shared value.

</details>

<details><summary>Hint 2</summary>

Use `GROUP BY customer_id` to group rows per customer, then apply an **aggregate function** to compute the total.

</details>

<details><summary>Hint 3</summary>

The aggregate function you need is `SUM(amount)`. Alias the result column as `total_amount`.

```sql
SELECT customer_id, SUM(amount) AS total_amount
FROM data
GROUP BY ...
```

</details>

## Solutions

### SQL

```sql
SELECT customer_id, SUM(amount) AS total_amount
FROM data
GROUP BY customer_id
```

**Why it works:**
- `GROUP BY customer_id` collapses all rows with the same `customer_id` into one group
- `SUM(amount)` computes the total amount within each group
- The alias `total_amount` gives the result column a clean name

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported
result = df \
    .groupBy("customer_id") \
    .agg(F.sum("amount").alias("total_amount"))
```

**Why it works:**
- `.groupBy("customer_id")` partitions the DataFrame by `customer_id`
- `.agg(F.sum("amount").alias("total_amount"))` computes the sum per group and names the output column
- `F.sum` is from `pyspark.sql.functions` — always use the functions module for aggregate operations
