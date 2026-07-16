# 10. Daily Sales Total

**Difficulty:** easy  
**Tags:** aggregation, groupby, date functions  
**Source:** https://spark.vutrinh.net/problems/daily_sales

## Problem

Given a table `sales` with columns `sale_id`, `store_id`, `sale_date`, and `amount`, compute the **total sales amount per day** across all stores.

Return columns: `sale_date`, `total_amount`, `num_transactions`

Order by `sale_date` ascending.

## Schema

**`sales`**

| column | type |
|---|---|
| sale_id | INT |
| store_id | INT |
| sale_date | STRING |
| amount | INT |

## Sample Input

**`sales`**

| sale_id | store_id | sale_date | amount |
|---|---|---|---|
| 1 | 1 | 2024-01-01 | 450 |
| 2 | 2 | 2024-01-01 | 820 |
| 3 | 1 | 2024-01-01 | 310 |
| 4 | 3 | 2024-01-02 | 650 |
| 5 | 1 | 2024-01-02 | 900 |

## Hints

<details><summary>Hint 1</summary>

You need to collapse multiple sales rows into one row per day — this is a `GROUP BY` on the date column.

</details>

<details><summary>Hint 2</summary>

Group by `sale_date` and use `SUM(amount)` for total and `COUNT(*)` for number of transactions.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT sale_date,
       SUM(amount) AS total_amount,
       COUNT(*) AS num_transactions
FROM sales
GROUP BY sale_date
ORDER BY sale_date
```

</details>

## Solutions

### SQL

```sql
SELECT sale_date,
       SUM(amount) AS total_amount,
       COUNT(*) AS num_transactions
FROM sales
GROUP BY sale_date
ORDER BY sale_date
```

**Why it works:**
- `GROUP BY sale_date` collapses all rows for the same date into one
- `SUM(amount)` totals the sales for that day
- `COUNT(*)` counts how many individual transactions happened

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .groupBy("sale_date")
    .agg(
        F.sum("amount").alias("total_amount"),
        F.count("*").alias("num_transactions")
    )
    .orderBy("sale_date")
)
```

**Why it works:**
- `.groupBy("sale_date")` groups all transactions by day
- `F.sum("amount")` totals daily sales
- `F.count("*")` counts transactions per day
