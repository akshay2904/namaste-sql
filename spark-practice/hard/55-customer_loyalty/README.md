# 55. Customer Loyalty Score

**Difficulty:** hard  
**Tags:** aggregation, joins, composite scoring  
**Source:** https://spark.vutrinh.net/problems/customer_loyalty

## Problem

# Customer Loyalty Score

**Difficulty:** Hard
**Tags:** aggregation, joins, composite scoring

## Background

The marketing team wants to rank customers by a composite loyalty score that balances purchase frequency, average spend, and customer satisfaction ratings.

## Schema

**orders** (`orders.csv`)

| Column | Type | Description |
|---|---|---|
| order_id | INT | Unique order identifier |
| customer_id | INT | Customer who placed the order |
| amount | INT | Order value in USD |
| order_date | STRING | Date the order was placed |

**ratings** (`ratings.csv`)

| Column | Type | Description |
|---|---|---|
| rating_id | INT | Unique rating identifier |
| customer_id | INT | Customer who left the rating |
| score | INT | Satisfaction score (1–5) |

## Task

Compute a loyalty score for each customer:

```
loyalty_score = ROUND(
    (total_orders * 0.3) + (avg_order_value * 0.5) + (avg_rating * 0.2),
    2
)
```

Return: **customer_id, total_orders, avg_order_value, avg_rating, loyalty_score**

- `avg_order_value` rounded to 2 decimal places
- `avg_rating` rounded to 2 decimal places
- `loyalty_score` rounded to 2 decimal places

Order by: **loyalty_score DESC**

## Sample Input

**`orders`**

| order_id | customer_id | amount | order_date |
|---|---|---|---|
| 1 | 1 | 120 | 2024-01-05 |
| 2 | 1 | 85 | 2024-01-12 |
| 3 | 1 | 200 | 2024-01-20 |
| 4 | 2 | 50 | 2024-01-03 |
| 5 | 2 | 75 | 2024-01-14 |

**`ratings`**

| rating_id | customer_id | score |
|---|---|---|
| 1 | 1 | 4 |
| 2 | 1 | 5 |
| 3 | 2 | 3 |
| 4 | 2 | 4 |
| 5 | 3 | 5 |

## Hints

<details><summary>Hint 1</summary>

# Concept: Composite Scoring via Aggregation and Join

This problem combines data from two separate tables using a join, then applies multi-column aggregation followed by a weighted formula.

## Pattern: Aggregate–Join–Compute

1. **Aggregate each table independently** to produce one row per customer.
2. **Join** the two aggregated results on `customer_id`.
3. **Apply the formula** to produce the composite score.

This is more efficient than joining the raw tables first and then aggregating, because each aggregation reduces the row count before the join.

## Rounding

Use `ROUND(expression, 2)` in SQL or `F.round(col, 2)` in the DataFrame API. Apply rounding to each intermediate metric as well as the final score, as specified in the problem.

## Weighted Formula

```
loyalty_score = (total_orders × 0.3) + (avg_order_value × 0.5) + (avg_rating × 0.2)
```

The weights reflect business priorities: average spend is the strongest driver, followed by frequency, then satisfaction.

</details>

<details><summary>Hint 2</summary>

# Approach

## Step-by-Step Plan

1. **Aggregate orders** per customer:
   - `COUNT(*)` → `total_orders`
   - `ROUND(AVG(amount), 2)` → `avg_order_value`
2. **Aggregate ratings** per customer:
   - `ROUND(AVG(score), 2)` → `avg_rating`
3. **Join** the two aggregated DataFrames on `customer_id`.
4. **Compute loyalty score**:
   ```
   ROUND((total_orders * 0.3) + (avg_order_value * 0.5) + (avg_rating * 0.2), 2)
   ```
5. **Select** `customer_id, total_orders, avg_order_value, avg_rating, loyalty_score`.
6. **Order** by `loyalty_score DESC`.

## Tips

- Use an inner join — every customer has both orders and ratings in this dataset.
- Cast the weights to `DOUBLE` or use decimal literals (`0.3`, `0.5`, `0.2`) to avoid integer arithmetic truncation.

</details>

<details><summary>Hint 3</summary>

# Query Hint

## SQL Skeleton

```sql
WITH order_stats AS (
    SELECT
        customer_id,
        COUNT(*)          AS total_orders,
        ROUND(AVG(amount), 2) AS avg_order_value
    FROM orders
    GROUP BY customer_id
),
rating_stats AS (
    SELECT
        customer_id,
        ROUND(AVG(score), 2) AS avg_rating
    FROM ratings
    GROUP BY customer_id
)
SELECT
    o.customer_id,
    o.total_orders,
    o.avg_order_value,
    r.avg_rating,
    ROUND((o.total_orders * 0.3) + (o.avg_order_value * 0.5) + (r.avg_rating * 0.2), 2) AS loyalty_score
FROM order_stats o
JOIN rating_stats r ON o.customer_id = r.customer_id
ORDER BY loyalty_score DESC
```

## DataFrame Skeleton

```python
order_stats = (
    orders.groupBy("customer_id")
          .agg(
              F.count("*").alias("total_orders"),
              F.round(F.avg("amount"), 2).alias("avg_order_value")
          )
)

rating_stats = (
    ratings.groupBy("customer_id")
           .agg(F.round(F.avg("score"), 2).alias("avg_rating"))
)

result = (
    order_stats.join(rating_stats, on="customer_id")
               .withColumn(
                   "loyalty_score",
                   F.round(
                       F.col("total_orders") * 0.3
                       + F.col("avg_order_value") * 0.5
                       + F.col("avg_rating") * 0.2,
                       2
                   )
               )
               .select("customer_id", "total_orders", "avg_order_value", "avg_rating", "loyalty_score")
               .orderBy(F.col("loyalty_score").desc())
)
```

</details>

## Solutions

### SQL

# Solution: SQL

```sql
WITH order_stats AS (
    SELECT
        customer_id,
        COUNT(*)              AS total_orders,
        ROUND(AVG(amount), 2) AS avg_order_value
    FROM orders
    GROUP BY customer_id
),
rating_stats AS (
    SELECT
        customer_id,
        ROUND(AVG(score), 2) AS avg_rating
    FROM ratings
    GROUP BY customer_id
)
SELECT
    o.customer_id,
    o.total_orders,
    o.avg_order_value,
    r.avg_rating,
    ROUND(
        (o.total_orders * 0.3) + (o.avg_order_value * 0.5) + (r.avg_rating * 0.2),
        2
    ) AS loyalty_score
FROM order_stats o
JOIN rating_stats r ON o.customer_id = r.customer_id
ORDER BY loyalty_score DESC
```

## Explanation

1. **`order_stats` CTE** — summarises each customer's order history: total order count and average spend (rounded to 2dp).
2. **`rating_stats` CTE** — computes each customer's average satisfaction rating (rounded to 2dp).
3. **Final SELECT** — joins the two summaries, applies the weighted loyalty formula, rounds to 2dp, and orders from highest to lowest score.

### DataFrame API

# Solution: DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

order_stats = (
    orders
    .groupBy("customer_id")
    .agg(
        F.count("*").alias("total_orders"),
        F.round(F.avg("amount"), 2).alias("avg_order_value"),
    )
)

rating_stats = (
    ratings
    .groupBy("customer_id")
    .agg(F.round(F.avg("score"), 2).alias("avg_rating"))
)

result = (
    order_stats
    .join(rating_stats, on="customer_id")
    .withColumn(
        "loyalty_score",
        F.round(
            F.col("total_orders") * 0.3
            + F.col("avg_order_value") * 0.5
            + F.col("avg_rating") * 0.2,
            2,
        )
    )
    .select("customer_id", "total_orders", "avg_order_value", "avg_rating", "loyalty_score")
    .orderBy(F.col("loyalty_score").desc())
)

result.show()
```

## Explanation

- Each table is aggregated independently before the join, keeping the computation efficient.
- The loyalty formula multiplies each metric by its weight, sums them, and rounds to two decimal places.
- `orderBy(F.col("loyalty_score").desc())` ranks from the most loyal customer downward.
