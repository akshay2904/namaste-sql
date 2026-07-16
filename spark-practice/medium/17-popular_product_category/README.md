# 17. Most Popular Product per Category

**Difficulty:** medium  
**Tags:** joins, window functions, ranking  
**Source:** https://spark.vutrinh.net/problems/popular_product_category

## Problem

Given tables `products` and `sales`, find the **most sold product (by total quantity) in each category**.

Return columns: `category`, `product_name`, `total_quantity`

Order by `category` ascending.

## Schema

**`products`**

| column | type |
|---|---|
| product_id | INT |
| product_name | STRING |
| category | STRING |

**`sales`**

| column | type |
|---|---|
| sale_id | INT |
| product_id | INT |
| quantity | INT |

## Sample Input

**`products`**

| product_id | product_name | category |
|---|---|---|
| 1 | Laptop Pro | Electronics |
| 2 | Wireless Mouse | Electronics |
| 3 | Standing Desk | Furniture |
| 4 | USB Hub | Electronics |
| 5 | Office Chair | Furniture |

**`sales`**

| sale_id | product_id | quantity |
|---|---|---|
| 1 | 1 | 5 |
| 2 | 2 | 12 |
| 3 | 3 | 3 |
| 4 | 4 | 8 |
| 5 | 5 | 6 |

## Hints

<details><summary>Hint 1</summary>

This combines a JOIN with aggregation and ranking — join products to sales, sum quantities per product, then find the top product within each category.

</details>

<details><summary>Hint 2</summary>

First join and aggregate total quantity per product:

```sql
SELECT p.category, p.product_name, SUM(s.quantity) AS total_quantity
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category, p.product_name
```

</details>

<details><summary>Hint 3</summary>

Then use `RANK() OVER (PARTITION BY category ORDER BY total_quantity DESC)` to rank within each category, and filter `rank = 1`:

```sql
SELECT category, product_name, total_quantity
FROM (
  SELECT category, product_name, total_quantity,
         RANK() OVER (PARTITION BY category ORDER BY total_quantity DESC) AS rank
  FROM (... aggregation ...)
)
WHERE rank = 1
```

</details>

## Solutions

### SQL

```sql
SELECT category, product_name, total_quantity
FROM (
  SELECT p.category, p.product_name,
         SUM(s.quantity) AS total_quantity,
         RANK() OVER (PARTITION BY p.category ORDER BY SUM(s.quantity) DESC) AS rank
  FROM products p
  JOIN sales s ON p.product_id = s.product_id
  GROUP BY p.category, p.product_name
)
WHERE rank = 1
ORDER BY category
```

**Why it works:**
- JOIN links products to their sales
- `GROUP BY` + `SUM` computes total quantity per product
- `RANK() OVER (PARTITION BY category ...)` ranks within each category
- Outer `WHERE rank = 1` keeps only the top product per category

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported
# products and sales are available as variables

window = Window.partitionBy("category").orderBy(F.desc("total_quantity"))

result = (
    products
    .join(sales, on="product_id")
    .groupBy("category", "product_name")
    .agg(F.sum("quantity").alias("total_quantity"))
    .withColumn("rank", F.rank().over(window))
    .filter(F.col("rank") == 1)
    .select("category", "product_name", "total_quantity")
    .orderBy("category")
)
```

**Why it works:**
- Join → aggregate total quantity per product per category
- `F.rank().over(window)` ranks within each category by quantity
- Filter rank == 1 to get the top product
