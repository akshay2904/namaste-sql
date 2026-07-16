# 8. Top N Overall

**Difficulty:** easy  
**Tags:** ordering, limit  
**Source:** https://spark.vutrinh.net/problems/top_n_overall

## Problem

Given a table `products` with columns `product_id`, `product_name`, `category`, and `total_sales`, return the **top 5 products by total sales**.

Return columns: `product_id`, `product_name`, `category`, `total_sales`

Order by `total_sales` descending.

## Schema

**`products`**

| column | type |
|---|---|
| product_id | INT |
| product_name | STRING |
| category | STRING |
| total_sales | INT |

## Sample Input

**`products`**

| product_id | product_name | category | total_sales |
|---|---|---|---|
| 1 | Laptop Pro | Electronics | 45000 |
| 2 | Wireless Mouse | Electronics | 8500 |
| 3 | Standing Desk | Furniture | 32000 |
| 4 | USB Hub | Electronics | 4200 |
| 5 | Office Chair | Furniture | 28000 |

## Hints

<details><summary>Hint 1</summary>

To get the "top N" overall, you simply need to **sort** the data and take the first N rows — no grouping or window functions needed when there's no partitioning requirement.

</details>

<details><summary>Hint 2</summary>

Use `ORDER BY total_sales DESC` to sort highest sales first.

</details>

<details><summary>Hint 3</summary>

Add `LIMIT 5` at the end of your query to keep only the top 5 rows. In DataFrame API use `.limit(5)`.

```sql
SELECT * FROM products
ORDER BY total_sales DESC
LIMIT 5
```

</details>

## Solutions

### SQL

```sql
SELECT product_id, product_name, category, total_sales
FROM products
ORDER BY total_sales DESC
LIMIT 5
```

**Why it works:**
- `ORDER BY total_sales DESC` sorts highest to lowest
- `LIMIT 5` keeps only the first 5 rows after sorting

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .orderBy(F.desc("total_sales"))
    .limit(5)
    .select("product_id", "product_name", "category", "total_sales")
)
```

**Why it works:**
- `.orderBy(F.desc("total_sales"))` sorts highest sales first
- `.limit(5)` keeps only the top 5 rows
