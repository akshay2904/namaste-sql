# 21. Conditional Aggregation

**Difficulty:** medium  
**Tags:** aggregation, case when  
**Source:** https://spark.vutrinh.net/problems/conditional_aggregation

## Problem

Given a table `orders` with columns `order_id`, `customer_id`, `status`, and `amount`, compute per customer:

- `completed_revenue` — total amount of completed orders
- `cancelled_revenue` — total amount of cancelled orders
- `total_orders` — total number of orders (all statuses)

Return columns: `customer_id`, `completed_revenue`, `cancelled_revenue`, `total_orders`

Order by `customer_id` ascending.

## Schema

**`orders`**

| column | type |
|---|---|
| order_id | INT |
| customer_id | INT |
| status | STRING |
| amount | INT |

## Sample Input

**`orders`**

| order_id | customer_id | status | amount |
|---|---|---|---|
| 1 | 1 | completed | 500 |
| 2 | 2 | completed | 800 |
| 3 | 1 | cancelled | 300 |
| 4 | 3 | completed | 650 |
| 5 | 2 | pending | 900 |

## Hints

<details><summary>Hint 1</summary>

**Conditional aggregation** computes different metrics based on conditions within a single GROUP BY — no need for multiple queries or self-joins.

</details>

<details><summary>Hint 2</summary>

Use `SUM(CASE WHEN status = 'completed' THEN amount ELSE 0 END)` to sum only matching rows.

In DataFrame API: `F.sum(F.when(F.col("status") == "completed", F.col("amount")).otherwise(0))`

</details>

<details><summary>Hint 3</summary>

```sql
SELECT customer_id,
       SUM(CASE WHEN status = 'completed' THEN amount ELSE 0 END) AS completed_revenue,
       SUM(CASE WHEN status = 'cancelled' THEN amount ELSE 0 END) AS cancelled_revenue,
       COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY customer_id
```

</details>

## Solutions

### SQL

```sql
SELECT customer_id,
       SUM(CASE WHEN status = 'completed' THEN amount ELSE 0 END) AS completed_revenue,
       SUM(CASE WHEN status = 'cancelled' THEN amount ELSE 0 END) AS cancelled_revenue,
       COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY customer_id
```

**Why it works:**
- `SUM(CASE WHEN ...)` sums only rows matching the condition, treating others as 0
- All three metrics computed in a single GROUP BY pass — efficient

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .groupBy("customer_id")
    .agg(
        F.sum(F.when(F.col("status") == "completed", F.col("amount")).otherwise(0)).alias("completed_revenue"),
        F.sum(F.when(F.col("status") == "cancelled", F.col("amount")).otherwise(0)).alias("cancelled_revenue"),
        F.count("*").alias("total_orders")
    )
    .orderBy("customer_id")
)
```

**Why it works:**
- `F.when(...).otherwise(0)` mirrors CASE WHEN ... ELSE 0
- `F.sum(...)` wraps it to sum only the matching amounts
