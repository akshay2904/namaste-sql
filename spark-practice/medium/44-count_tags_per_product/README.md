# 44. Count Tags per Product

**Difficulty:** medium  
**Tags:** explode, groupby  
**Source:** https://spark.vutrinh.net/problems/count_tags_per_product

## Problem

Given a table `products` with columns `product_id`, `product_name`, and `tags` (a comma-separated string of tags), count how many tags each product has.

Return columns: `product_id`, `product_name`, `tag_count`

Order by `tag_count` DESC, then `product_id` ASC.

## Schema

**`products`**

| column | type |
|---|---|
| product_id | INT |
| product_name | STRING |
| tags | STRING |

## Sample Input

**`products`**

| product_id | product_name | tags |
|---|---|---|
| 1 | Laptop | electronics,portable,computing |
| 2 | Headphones | electronics,audio,wireless |
| 3 | Running Shoes | footwear,sports,outdoor |
| 4 | Coffee Maker | kitchen,appliance |
| 5 | Yoga Mat | sports,fitness,outdoor |

## Hints

<details><summary>Hint 1</summary>

To count elements in a comma-separated string, first `SPLIT` the string into an array, then `EXPLODE` the array so each element becomes its own row. After the explode, a simple `COUNT(*)` grouped by product gives the tag count. Alternatively, `SIZE(SPLIT(...))` can count array elements directly without exploding.

</details>

<details><summary>Hint 2</summary>

1. Use a subquery (or CTE) to `EXPLODE(SPLIT(tags, ','))` so each tag becomes a separate row.
2. In the outer query, `GROUP BY product_id, product_name` and `COUNT(*)` to get `tag_count`.
3. Order by `tag_count DESC`, then `product_id ASC` to break ties.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT product_id, product_name, COUNT(*) AS tag_count
FROM (
  SELECT product_id, product_name, EXPLODE(SPLIT(tags, ',')) AS tag
  FROM products
)
GROUP BY product_id, product_name
ORDER BY tag_count DESC, product_id
```

</details>

## Solutions

### SQL

```sql
SELECT product_id, product_name, COUNT(*) AS tag_count
FROM (
  SELECT product_id, product_name, EXPLODE(SPLIT(tags, ',')) AS tag
  FROM products
)
GROUP BY product_id, product_name
ORDER BY tag_count DESC, product_id
```

**Why it works:**
- `SPLIT(tags, ',')` converts the comma-separated string into an array.
- `EXPLODE(...)` turns each array element into a separate row so `COUNT(*)` can tally them.
- Ordering by `tag_count DESC, product_id ASC` produces a deterministic result.

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .withColumn("tag", F.explode(F.split(F.col("tags"), ",")))
    .groupBy("product_id", "product_name")
    .agg(F.count("tag").alias("tag_count"))
    .orderBy(F.col("tag_count").desc(), F.col("product_id").asc())
)
```

**Why it works:**
- `F.split` and `F.explode` expand each comma-separated tag string into individual rows.
- After grouping, `F.count("tag")` tallies the tags per product.
- Dual sort (`tag_count DESC`, `product_id ASC`) ensures a deterministic order.
