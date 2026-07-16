# 16. Unsold Products

**Difficulty:** medium  
**Tags:** joins, anti-join  
**Source:** https://spark.vutrinh.net/problems/unsold_products

## Problem

Given tables `products` and `sales`, find all products that have **never been sold**.

Return columns: `product_id`, `product_name`, `category`, `price`

Order by `product_id` ascending.

## Schema

**`products`**

| column | type |
|---|---|
| product_id | INT |
| product_name | STRING |
| category | STRING |
| price | INT |

**`sales`**

| column | type |
|---|---|
| sale_id | INT |
| product_id | INT |
| quantity | INT |
| sale_date | STRING |

## Sample Input

**`products`**

| product_id | product_name | category | price |
|---|---|---|---|
| 1 | Laptop | Electronics | 1200 |
| 2 | Phone | Electronics | 800 |
| 3 | Tablet | Electronics | 500 |
| 4 | Monitor | Electronics | 950 |
| 5 | Keyboard | Accessories | 120 |

**`sales`**

| sale_id | product_id | quantity | sale_date |
|---|---|---|---|
| 1 | 1 | 2 | 2024-01-01 |
| 2 | 2 | 5 | 2024-01-02 |
| 3 | 3 | 1 | 2024-01-03 |
| 4 | 1 | 3 | 2024-01-04 |
| 5 | 5 | 10 | 2024-01-05 |

## Hints

<details><summary>Hint 1</summary>

Similar to "Customers with No Orders" — this is another **anti-join** pattern. You want products that have no matching rows in the sales table.

</details>

<details><summary>Hint 2</summary>

Use `LEFT JOIN` products to sales, then filter where `sale_id IS NULL`. Or use `NOT IN` / `NOT EXISTS` subquery approach.

In DataFrame API, Spark's `left_anti` join is the most elegant solution.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT p.product_id, p.product_name, p.category, p.price
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL
ORDER BY p.product_id
```

</details>

## Solutions

### SQL

```sql
SELECT p.product_id, p.product_name, p.category, p.price
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL
ORDER BY p.product_id
```

**Why it works:**
- `LEFT JOIN` keeps all products, filling NULL for sale columns with no match
- `WHERE s.sale_id IS NULL` keeps only products never sold

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported
# products and sales are available as variables

result = (
    products
    .join(sales, on="product_id", how="left_anti")
    .select("product_id", "product_name", "category", "price")
    .orderBy("product_id")
)
```

**Why it works:**
- `how="left_anti"` is Spark's built-in anti-join — returns only rows from `products` with no match in `sales`
- Cleaner than LEFT JOIN + IS NULL filter
