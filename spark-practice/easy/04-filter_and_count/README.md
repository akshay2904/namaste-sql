# 4. Filter and Count

**Difficulty:** easy  
**Tags:** filtering, aggregation, count distinct  
**Source:** https://spark.vutrinh.net/problems/filter_and_count

## Problem

Given a table `orders` with columns `order_id`, `customer_id`, `product`, `country`, and `amount`, find the **number of distinct customers** and **total revenue** for orders from `USA` only.

Return columns: `country`, `distinct_customers`, `total_revenue`

## Schema

**`orders`**

| column | type |
|---|---|
| order_id | INT |
| customer_id | INT |
| product | STRING |
| country | STRING |
| amount | INT |

## Sample Input

**`orders`**

| order_id | customer_id | product | country | amount |
|---|---|---|---|---|
| 1 | 1 | Laptop | USA | 1200 |
| 2 | 2 | Phone | UK | 800 |
| 3 | 1 | Tablet | USA | 500 |
| 4 | 3 | Laptop | Canada | 1200 |
| 5 | 2 | Laptop | UK | 1200 |

## Hints

<details><summary>Hint 1</summary>

You need two things: **filter** rows to a specific country, then **aggregate** to get counts and totals.

</details>

<details><summary>Hint 2</summary>

Use `COUNT(DISTINCT customer_id)` to count unique customers — a customer who placed multiple orders should only be counted once.

</details>

<details><summary>Hint 3</summary>

Filter first with `WHERE country = 'USA'`, then aggregate:

```sql
SELECT country,
       COUNT(DISTINCT customer_id) AS distinct_customers,
       SUM(amount) AS total_revenue
FROM orders
WHERE country = 'USA'
GROUP BY country
```

</details>

## Solutions

### SQL

```sql
SELECT country,
       COUNT(DISTINCT customer_id) AS distinct_customers,
       SUM(amount) AS total_revenue
FROM orders
WHERE country = 'USA'
GROUP BY country
```

**Why it works:**
- `WHERE country = 'USA'` filters before aggregation
- `COUNT(DISTINCT customer_id)` counts unique customers only
- `SUM(amount)` totals revenue for filtered rows

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .filter(F.col("country") == "USA")
    .groupBy("country")
    .agg(
        F.countDistinct("customer_id").alias("distinct_customers"),
        F.sum("amount").alias("total_revenue")
    )
)
```

**Why it works:**
- `.filter(...)` narrows to USA orders only
- `F.countDistinct("customer_id")` counts unique customers
- `F.sum("amount")` totals revenue
