# 41. Late Deliveries

**Difficulty:** medium  
**Tags:** date functions, datediff, filtering  
**Source:** https://spark.vutrinh.net/problems/late_deliveries

## Problem

Given a table `orders` with columns `order_id`, `customer_id`, `order_date`, `delivery_date`, and `promised_days`, find all orders that were **delivered late**.

An order is late when the actual delivery took more days than promised:
- `actual_days = DATEDIFF(delivery_date, order_date)`
- `days_late = actual_days - promised_days`
- Late means `actual_days > promised_days`

Return columns: `order_id`, `customer_id`, `promised_days`, `actual_days`, `days_late`

Order by `days_late` descending.

## Schema

**`orders`**

| column | type |
|---|---|
| order_id | INT |
| customer_id | INT |
| order_date | STRING |
| delivery_date | STRING |
| promised_days | INT |

## Sample Input

**`orders`**

| order_id | customer_id | order_date | delivery_date | promised_days |
|---|---|---|---|---|
| 1 | 301 | 2024-01-05 | 2024-01-08 | 5 |
| 2 | 302 | 2024-01-07 | 2024-01-15 | 5 |
| 3 | 303 | 2024-01-10 | 2024-01-13 | 3 |
| 4 | 304 | 2024-01-12 | 2024-01-20 | 5 |
| 5 | 305 | 2024-01-15 | 2024-01-17 | 3 |

## Hints

<details><summary>Hint 1</summary>

`DATEDIFF(end_date, start_date)` returns the number of days between two dates. Compare this actual number of days against the `promised_days` column to determine whether an order was late.

</details>

<details><summary>Hint 2</summary>

1. Compute `actual_days = DATEDIFF(delivery_date, order_date)`.
2. Compute `days_late = actual_days - promised_days`.
3. Filter rows where `actual_days > promised_days` (equivalently, `days_late > 0`).
4. Select `order_id`, `customer_id`, `promised_days`, `actual_days`, `days_late`.
5. Order by `days_late` descending.

You can do steps 1–3 in a subquery or CTE, then filter in the outer query.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT order_id, customer_id, promised_days, actual_days,
       actual_days - promised_days AS days_late
FROM (
  SELECT *, DATEDIFF(delivery_date, order_date) AS actual_days
  FROM orders
) t
WHERE actual_days > promised_days
ORDER BY days_late DESC
```

</details>

## Solutions

### SQL

```sql
SELECT order_id, customer_id, promised_days, actual_days,
       actual_days - promised_days AS days_late
FROM (
  SELECT *, DATEDIFF(delivery_date, order_date) AS actual_days
  FROM orders
) t
WHERE actual_days > promised_days
ORDER BY days_late DESC
```

**Why it works:**
- The inner query adds `actual_days` via `DATEDIFF(delivery_date, order_date)` — note end date comes first
- The outer `WHERE actual_days > promised_days` keeps only late deliveries
- `days_late` is computed as the difference between actual and promised, showing how many extra days were taken
- `ORDER BY days_late DESC` surfaces the most-delayed orders first

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .withColumn("actual_days", F.datediff(F.col("delivery_date"), F.col("order_date")))
    .withColumn("days_late", F.col("actual_days") - F.col("promised_days"))
    .filter(F.col("actual_days") > F.col("promised_days"))
    .select("order_id", "customer_id", "promised_days", "actual_days", "days_late")
    .orderBy(F.col("days_late").desc())
)
```

**Why it works:**
- `F.datediff(end, start)` returns the integer number of days — delivery_date minus order_date
- `.withColumn("days_late", ...)` computes the delay in one step
- `.filter(...)` removes on-time and early deliveries
- `.orderBy(F.col("days_late").desc())` sorts from most delayed to least
