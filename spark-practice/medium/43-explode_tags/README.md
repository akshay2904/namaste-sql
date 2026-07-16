# 43. Explode Tags to Rows

**Difficulty:** medium  
**Tags:** explode, array to rows  
**Source:** https://spark.vutrinh.net/problems/explode_tags

## Problem

Given a table `products_with_arrays` with columns `product_id`, `product_name`, and `tags` (a comma-separated string of tags), **split and explode** the tags so that each tag gets its own row.

Return columns: `product_id`, `product_name`, `tag`

Order by `product_id` ascending, then `tag` ascending.

> Hint: Use `SPLIT(tags, ',')` to turn the string into an array, then `EXPLODE(...)` to expand the array into rows.

## Schema

**`products_with_arrays`**

| column | type |
|---|---|
| product_id | INT |
| product_name | STRING |
| tags | STRING |

## Sample Input

**`products_with_arrays`**

| product_id | product_name | tags |
|---|---|---|
| 1 | Laptop | electronics,portable,computing |
| 2 | Headphones | electronics,audio,wireless |
| 3 | Running Shoes | footwear,sports,outdoor |
| 4 | Coffee Maker | kitchen,appliance |
| 5 | Yoga Mat | sports,fitness,outdoor |

## Hints

<details><summary>Hint 1</summary>

`EXPLODE` is a table-generating function (also called a lateral view in some dialects). It takes an array and produces one output row per element. Combined with `SPLIT`, which converts a delimited string into an array, you can normalize a denormalized comma-separated column into a proper one-row-per-value structure.

</details>

<details><summary>Hint 2</summary>

1. Use `SPLIT(tags, ',')` to convert the comma-separated string into an array.
2. Wrap it in `EXPLODE(...)` to produce one row per tag.
3. Select `product_id`, `product_name`, and the exploded value aliased as `tag`.
4. Order by `product_id`, then `tag`.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT product_id, product_name, EXPLODE(SPLIT(tags, ',')) AS tag
FROM products_with_arrays
ORDER BY product_id, tag
```

</details>

## Solutions

### SQL

```sql
SELECT product_id, product_name, EXPLODE(SPLIT(tags, ',')) AS tag
FROM products_with_arrays
ORDER BY product_id, tag
```

**Why it works:**
- `SPLIT(tags, ',')` converts the comma-separated string into an array of strings
- `EXPLODE(...)` expands the array — one output row per element
- The result is aliased as `tag` for a clean column name
- Ordering by `product_id` then `tag` gives a stable, deterministic result

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .withColumn("tag", F.explode(F.split(F.col("tags"), ",")))
    .select("product_id", "product_name", "tag")
    .orderBy("product_id", "tag")
)
```

**Why it works:**
- `F.split(F.col("tags"), ",")` produces an `ArrayType(StringType)` column
- `F.explode(...)` turns each array element into a separate row, dropping the original array column
- `.select(...)` keeps only the required columns in the correct order
- `.orderBy("product_id", "tag")` produces a deterministic ordering
