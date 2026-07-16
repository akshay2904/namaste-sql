# 7. Column Arithmetic

**Difficulty:** easy  
**Tags:** derived columns, arithmetic, rounding  
**Source:** https://spark.vutrinh.net/problems/column_arithmetic

## Problem

Given a table `products` with columns `product_id`, `product_name`, `price`, `quantity`, and `discount_pct`, compute the following for each product:

- `discounted_price` = `price * (1 - discount_pct / 100)`  (rounded to 2 decimal places)
- `total_revenue` = `discounted_price * quantity`  (rounded to 2 decimal places)

Return columns: `product_id`, `product_name`, `discounted_price`, `total_revenue`

Order by `total_revenue` descending.

## Schema

**`products`**

| column | type |
|---|---|
| product_id | INT |
| product_name | STRING |
| price | INT |
| quantity | INT |
| discount_pct | INT |

## Sample Input

**`products`**

| product_id | product_name | price | quantity | discount_pct |
|---|---|---|---|---|
| 1 | Laptop | 1200 | 5 | 10 |
| 2 | Phone | 800 | 12 | 15 |
| 3 | Tablet | 500 | 8 | 5 |
| 4 | Monitor | 950 | 3 | 20 |
| 5 | Keyboard | 120 | 25 | 0 |

## Hints

<details><summary>Hint 1</summary>

You need to create **new columns derived from existing ones** using arithmetic operations. No grouping needed — compute a value for each row.

</details>

<details><summary>Hint 2</summary>

Use `ROUND(expression, 2)` in SQL or `F.round(F.col(...), 2)` in DataFrame API to round to 2 decimal places.

Watch out for integer division — `discount_pct / 100` with integer columns may truncate. Cast to float: `discount_pct / 100.0`.

</details>

<details><summary>Hint 3</summary>

Build the derived columns step by step:

```sql
SELECT product_id, product_name,
       ROUND(price * (1 - discount_pct / 100.0), 2) AS discounted_price,
       ROUND(price * (1 - discount_pct / 100.0) * quantity, 2) AS total_revenue
FROM products
ORDER BY total_revenue DESC
```

</details>

## Solutions

### SQL

```sql
SELECT product_id, product_name,
       ROUND(price * (1 - discount_pct / 100.0), 2) AS discounted_price,
       ROUND(price * (1 - discount_pct / 100.0) * quantity, 2) AS total_revenue
FROM products
ORDER BY total_revenue DESC
```

**Why it works:**
- `discount_pct / 100.0` uses float division to avoid integer truncation
- `price * (1 - ...)` computes the discounted price per unit
- Multiply by `quantity` for total revenue
- `ROUND(..., 2)` rounds to 2 decimal places

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

discounted = F.round(F.col("price") * (1 - F.col("discount_pct") / 100.0), 2)

result = (
    df
    .withColumn("discounted_price", discounted)
    .withColumn("total_revenue", F.round(discounted * F.col("quantity"), 2))
    .select("product_id", "product_name", "discounted_price", "total_revenue")
    .orderBy(F.desc("total_revenue"))
)
```

**Why it works:**
- Define `discounted` as a reusable column expression
- `.withColumn()` adds derived columns one at a time
- `F.round(..., 2)` rounds to 2 decimal places
