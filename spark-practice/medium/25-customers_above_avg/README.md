# 25. Customers Above Average Spend

**Difficulty:** medium  
**Tags:** aggregation, having, subquery  
**Source:** https://spark.vutrinh.net/problems/customers_above_avg

## Problem

Given a table `orders` with columns `order_id`, `customer_id`, and `amount`, find all customers whose **total spend** is above the **average total spend** across all customers.

Return columns: `customer_id`, `total_spend`

Order by `total_spend` descending.

## Schema

**`orders`**

| column | type |
|---|---|
| order_id | INT |
| customer_id | INT |
| amount | INT |

## Sample Input

**`orders`**

| order_id | customer_id | amount |
|---|---|---|
| 1 | 101 | 150 |
| 2 | 102 | 200 |
| 3 | 101 | 300 |
| 4 | 103 | 50 |
| 5 | 104 | 400 |

## Hints

<details><summary>Hint 1</summary>

This is a two-step problem: first aggregate per customer to get total spend, then filter to only keep customers whose total exceeds the average of all totals. The average is computed over the already-aggregated values, not the raw rows.

</details>

<details><summary>Hint 2</summary>

In SQL: use a subquery or CTE to compute `total_spend` per customer, then wrap it with `HAVING total_spend > (SELECT AVG(total_spend) FROM ...)`.

In the DataFrame API: compute the per-customer totals first, then derive the average of those totals and filter.

</details>

<details><summary>Hint 3</summary>

```sql
WITH customer_totals AS (
    SELECT customer_id, SUM(amount) AS total_spend
    FROM orders
    GROUP BY customer_id
)
SELECT customer_id, total_spend
FROM customer_totals
WHERE total_spend > (SELECT AVG(total_spend) FROM customer_totals)
ORDER BY total_spend DESC
```

</details>

## Solutions

### SQL

```sql
WITH customer_totals AS (
    SELECT customer_id, SUM(amount) AS total_spend
    FROM orders
    GROUP BY customer_id
)
SELECT customer_id, total_spend
FROM customer_totals
WHERE total_spend > (SELECT AVG(total_spend) FROM customer_totals)
ORDER BY total_spend DESC
```

**Why it works:**
- The CTE computes total spend per customer once
- The scalar subquery `(SELECT AVG(total_spend) FROM customer_totals)` returns the average of the per-customer totals
- `WHERE total_spend > ...` filters to only above-average customers

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

totals = (
    df
    .groupBy("customer_id")
    .agg(F.sum("amount").alias("total_spend"))
)

avg_spend = totals.agg(F.avg("total_spend")).collect()[0][0]

result = (
    totals
    .filter(F.col("total_spend") > avg_spend)
    .orderBy(F.col("total_spend").desc())
)
```

**Why it works:**
- First aggregation computes per-customer totals
- `.collect()[0][0]` pulls the single average value to the driver
- The filter then compares each customer's total against that scalar
