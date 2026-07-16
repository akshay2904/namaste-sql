# 19. Monthly Revenue Summary

**Difficulty:** medium  
**Tags:** aggregation, date functions  
**Source:** https://spark.vutrinh.net/problems/monthly_revenue

## Problem

Given a table `orders` with columns `order_id`, `order_date`, `amount`, and `category`, compute the **total revenue and number of orders per month**.

Return columns: `month`, `total_revenue`, `num_orders`

Where `month` is formatted as `yyyy-MM` (e.g. `2024-01`).

Order by `month` ascending.

## Schema

**`orders`**

| column | type |
|---|---|
| order_id | INT |
| order_date | STRING |
| amount | INT |
| category | STRING |

## Sample Input

**`orders`**

| order_id | order_date | amount | category |
|---|---|---|---|
| 1 | 2024-01-05 | 1200 | Electronics |
| 2 | 2024-01-15 | 800 | Clothing |
| 3 | 2024-01-28 | 500 | Electronics |
| 4 | 2024-02-03 | 950 | Furniture |
| 5 | 2024-02-14 | 300 | Clothing |

## Hints

<details><summary>Hint 1</summary>

You need to **extract the year and month** from a date column, then group by it. The key is formatting the date into a `yyyy-MM` string before grouping.

</details>

<details><summary>Hint 2</summary>

Use `DATE_FORMAT(order_date, 'yyyy-MM')` in Spark SQL to extract the year-month string.

In DataFrame API: `F.date_format(F.col("order_date"), "yyyy-MM")`

</details>

<details><summary>Hint 3</summary>

```sql
SELECT DATE_FORMAT(order_date, 'yyyy-MM') AS month,
       SUM(amount) AS total_revenue,
       COUNT(*) AS num_orders
FROM orders
GROUP BY DATE_FORMAT(order_date, 'yyyy-MM')
ORDER BY month
```

</details>

## Solutions

### SQL

```sql
SELECT DATE_FORMAT(order_date, 'yyyy-MM') AS month,
       SUM(amount) AS total_revenue,
       COUNT(*) AS num_orders
FROM orders
GROUP BY DATE_FORMAT(order_date, 'yyyy-MM')
ORDER BY month
```

**Why it works:**
- `DATE_FORMAT(order_date, 'yyyy-MM')` extracts year-month as a string
- `GROUP BY` on that string collapses all orders in the same month
- `SUM` and `COUNT` aggregate revenue and order count

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .withColumn("month", F.date_format(F.col("order_date"), "yyyy-MM"))
    .groupBy("month")
    .agg(
        F.sum("amount").alias("total_revenue"),
        F.count("*").alias("num_orders")
    )
    .orderBy("month")
)
```

**Why it works:**
- `F.date_format(...)` creates a `yyyy-MM` string column
- `.groupBy("month")` groups all orders in the same month
- `.agg(...)` computes both metrics in one step
