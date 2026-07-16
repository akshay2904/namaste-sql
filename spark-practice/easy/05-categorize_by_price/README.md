# 5. Categorize by Price

**Difficulty:** easy  
**Tags:** case when, conditional logic  
**Source:** https://spark.vutrinh.net/problems/categorize_by_price

## Problem

Given a table `products` with columns `product_id`, `product_name`, `category`, and `price`, add a `price_tier` column based on the following rules:

- `price < 50` → `'Budget'`
- `price >= 50` AND `price < 500` → `'Mid-range'`
- `price >= 500` → `'Premium'`

Return columns: `product_id`, `product_name`, `price`, `price_tier`

Order by `price` ascending.

## Schema

**`products`**

| column | type |
|---|---|
| product_id | INT |
| product_name | STRING |
| category | STRING |
| price | INT |

## Sample Input

**`products`**

| product_id | product_name | category | price |
|---|---|---|---|
| 1 | Laptop Pro | Electronics | 2500 |
| 2 | Wireless Mouse | Electronics | 35 |
| 3 | Standing Desk | Furniture | 850 |
| 4 | USB Hub | Electronics | 45 |
| 5 | Office Chair | Furniture | 420 |

## Hints

<details><summary>Hint 1</summary>

You need to assign a label to each row based on a condition. This is a **conditional column** — no grouping needed, just row-by-row logic.

</details>

<details><summary>Hint 2</summary>

Use `CASE WHEN ... THEN ... ELSE ... END` in SQL, or `F.when(...).when(...).otherwise(...)` in DataFrame API.

```sql
CASE
  WHEN price < 50 THEN 'Budget'
  WHEN price < 500 THEN 'Mid-range'
  ELSE 'Premium'
END AS price_tier
```

</details>

<details><summary>Hint 3</summary>

Once you have the `price_tier` column, select only the required columns and order by `price` ascending.

```sql
SELECT product_id, product_name, price,
       CASE WHEN price < 50 THEN 'Budget'
            WHEN price < 500 THEN 'Mid-range'
            ELSE 'Premium' END AS price_tier
FROM products
ORDER BY price
```

</details>

## Solutions

### SQL

```sql
SELECT product_id, product_name, price,
       CASE
         WHEN price < 50 THEN 'Budget'
         WHEN price < 500 THEN 'Mid-range'
         ELSE 'Premium'
       END AS price_tier
FROM products
ORDER BY price
```

**Why it works:**
- `CASE WHEN` evaluates conditions in order — first match wins
- `price < 500` in the second condition implicitly means `>= 50` since the first condition already handles `< 50`
- `ELSE 'Premium'` catches everything `>= 500`

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .withColumn("price_tier",
        F.when(F.col("price") < 50, "Budget")
         .when(F.col("price") < 500, "Mid-range")
         .otherwise("Premium")
    )
    .select("product_id", "product_name", "price", "price_tier")
    .orderBy("price")
)
```

**Why it works:**
- `F.when(...).when(...).otherwise(...)` chains conditions like CASE WHEN
- Conditions are evaluated in order — first match wins
- `.otherwise("Premium")` is the ELSE clause
