# 20. Revenue Share per Category

**Difficulty:** medium  
**Tags:** aggregation, window functions, percentage  
**Source:** https://spark.vutrinh.net/problems/revenue_share

## Problem

Given a table `orders` with columns `order_id`, `category`, and `amount`, compute the **total revenue and percentage share** of each category.

Return columns: `category`, `total_revenue`, `revenue_pct`

Where `revenue_pct` is rounded to 2 decimal places (e.g. `48.05` means 48.05%).

Order by `revenue_pct` descending.

## Schema

**`orders`**

| column | type |
|---|---|
| order_id | INT |
| category | STRING |
| amount | INT |

## Sample Input

**`orders`**

| order_id | category | amount |
|---|---|---|
| 1 | Electronics | 1200 |
| 2 | Clothing | 800 |
| 3 | Electronics | 500 |
| 4 | Furniture | 950 |
| 5 | Clothing | 300 |

## Hints

<details><summary>Hint 1</summary>

To compute a percentage, you need **each category's revenue divided by the total revenue**. The challenge is getting the total revenue alongside the per-category sum.

</details>

<details><summary>Hint 2</summary>

Use `SUM(amount) OVER ()` — a window function with no partition — to get the grand total alongside each row's group sum:

```sql
SUM(SUM(amount)) OVER () AS grand_total
```

Or use a subquery / CTE to compute total separately.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT category, total_revenue,
       ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER (), 2) AS revenue_pct
FROM (
  SELECT category, SUM(amount) AS total_revenue
  FROM orders
  GROUP BY category
)
ORDER BY revenue_pct DESC
```

</details>

## Solutions

### SQL

```sql
SELECT category, total_revenue,
       ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER (), 2) AS revenue_pct
FROM (
  SELECT category, SUM(amount) AS total_revenue
  FROM orders
  GROUP BY category
)
ORDER BY revenue_pct DESC
```

**Why it works:**
- Inner query computes total revenue per category
- `SUM(total_revenue) OVER ()` — window with no PARTITION gets the grand total
- Dividing by grand total gives the percentage share

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

totals = (
    df.groupBy("category")
    .agg(F.sum("amount").alias("total_revenue"))
)

grand_total_window = Window.rowsBetween(Window.unboundedPreceding, Window.unboundedFollowing)

result = (
    totals
    .withColumn("revenue_pct",
        F.round(F.col("total_revenue") * 100.0 / F.sum("total_revenue").over(grand_total_window), 2)
    )
    .orderBy(F.desc("revenue_pct"))
)
```

**Why it works:**
- Aggregate per category first
- `Window.rowsBetween(unboundedPreceding, unboundedFollowing)` spans all rows — gives grand total
- Divide to get percentage, round to 2 decimal places
