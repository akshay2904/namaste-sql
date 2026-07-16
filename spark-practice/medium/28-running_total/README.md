# 28. Running Total

**Difficulty:** medium  
**Tags:** window functions, aggregation  
**Source:** https://spark.vutrinh.net/problems/running_total

## Problem

Given a table `orders` with columns `order_date`, `customer_id`, and `amount`, compute the **running total of amount per customer**, ordered by `order_date`.

Return columns: `customer_id`, `order_date`, `amount`, `running_total`

Order the result by `customer_id` ascending, then `order_date` ascending.

**Hint:** Use `SUM() OVER (PARTITION BY ... ORDER BY ... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`.

## Schema

**`orders`**

| column | type |
|---|---|
| order_date | STRING |
| customer_id | INT |
| amount | INT |

## Sample Input

**`orders`**

| order_date | customer_id | amount |
|---|---|---|
| 2024-01-01 | 1 | 150 |
| 2024-01-02 | 1 | 200 |
| 2024-01-03 | 1 | 100 |
| 2024-01-01 | 2 | 300 |
| 2024-01-02 | 2 | 50 |

## Hints

<details><summary>Hint 1</summary>

A running total means each row shows the **cumulative sum** of all previous rows up to and including the current one, within each group.

</details>

<details><summary>Hint 2</summary>

Use `SUM() OVER (PARTITION BY customer_id ORDER BY order_date)` — the window orders rows by date so the sum accumulates chronologically per customer.

</details>

<details><summary>Hint 3</summary>

Explicitly define the window frame to include all rows from the start up to the current row:

```sql
SUM(amount) OVER (
  PARTITION BY customer_id
  ORDER BY order_date
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS running_total
```

</details>

## Solutions

### SQL

```sql
SELECT customer_id, order_date, amount,
       SUM(amount) OVER (
         PARTITION BY customer_id
         ORDER BY order_date
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total
FROM orders
ORDER BY customer_id, order_date
```

**Why it works:**
- `PARTITION BY customer_id` resets the running total per customer
- `ORDER BY order_date` ensures the sum accumulates chronologically
- `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` explicitly includes all rows from the start of the partition to the current row

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

window = (
    Window
    .partitionBy("customer_id")
    .orderBy("order_date")
    .rowsBetween(Window.unboundedPreceding, Window.currentRow)
)

result = df \
    .withColumn("running_total", F.sum("amount").over(window)) \
    .select("customer_id", "order_date", "amount", "running_total") \
    .orderBy("customer_id", "order_date")
```

**Why it works:**
- `Window.partitionBy("customer_id")` resets the sum per customer
- `.orderBy("order_date")` accumulates chronologically
- `.rowsBetween(Window.unboundedPreceding, Window.currentRow)` includes all rows from the partition start to current
