# 42. Aggregate Tags into Array

**Difficulty:** medium  
**Tags:** collect_list, spark specific  
**Source:** https://spark.vutrinh.net/problems/aggregate_tags

## Problem

Given a table `products` with columns `product_id`, `product_name`, and `tag` (one tag per row), aggregate all tags for each product into an **array**.

Return columns: `product_id`, `product_name`, `tags` (array of strings collected with `COLLECT_LIST`)

Order by `product_id` ascending.

## Schema

**`products`**

| column | type |
|---|---|
| product_id | INT |
| product_name | STRING |
| tag | STRING |

## Sample Input

**`products`**

| product_id | product_name | tag |
|---|---|---|
| 1 | Laptop | electronics |
| 1 | Laptop | portable |
| 1 | Laptop | computing |
| 2 | Headphones | electronics |
| 2 | Headphones | audio |

## Hints

<details><summary>Hint 1</summary>

`COLLECT_LIST` is a Spark-specific aggregate function that gathers all values in a group into an array. Unlike standard SQL, Spark supports array-typed result columns natively. Note that `COLLECT_LIST` does not guarantee element order within the array — the order depends on the physical execution plan.

</details>

<details><summary>Hint 2</summary>

1. Group by `product_id` and `product_name`.
2. Use `COLLECT_LIST(tag)` to gather all tag values into an array column called `tags`.
3. Order the result by `product_id` ascending.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT product_id, product_name, COLLECT_LIST(tag) AS tags
FROM products
GROUP BY product_id, product_name
ORDER BY product_id
```

</details>

## Solutions

### SQL

```sql
SELECT product_id, product_name, ARRAY_JOIN(ARRAY_SORT(COLLECT_LIST(tag)), ',') AS tags
FROM products
GROUP BY product_id, product_name
ORDER BY product_id
```

**Why it works:**
- `COLLECT_LIST(tag)` aggregates all tags into an array
- `ARRAY_SORT(...)` sorts the array for consistent ordering
- `ARRAY_JOIN(..., ',')` converts the array to a comma-separated string for comparison

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .groupBy("product_id", "product_name")
    .agg(F.array_join(F.array_sort(F.collect_list("tag")), ",").alias("tags"))
    .orderBy("product_id")
)
```

**Why it works:**
- `F.collect_list("tag")` aggregates tags into an array
- `F.array_sort(...)` ensures consistent ordering
- `F.array_join(..., ",")` converts to a string for reliable comparison
