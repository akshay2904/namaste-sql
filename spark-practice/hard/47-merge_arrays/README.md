# 47. Merge Arrays Across Rows

**Difficulty:** hard  
**Tags:** collect_list, flatten, spark specific  
**Source:** https://spark.vutrinh.net/problems/merge_arrays

## Problem

Given a table `user_purchases` with columns `user_id`, `purchase_date`, and `items` (a comma-separated list of purchased items per transaction), collect all items a user has ever purchased into a **single deduplicated array**.

Return columns: `user_id`, `all_items` (array of unique items, sorted alphabetically)

Order by `user_id` ascending.

## Schema

**`user_purchases`**

| column | type |
|---|---|
| user_id | INT |
| purchase_date | STRING |
| items | STRING |

## Sample Input

**`user_purchases`**

| user_id | purchase_date | items |
|---|---|---|
| 1 | 2024-01-05 | laptop,mouse,keyboard |
| 1 | 2024-01-20 | monitor,keyboard |
| 2 | 2024-01-08 | phone,case |
| 2 | 2024-01-15 | earbuds,phone,charger |
| 3 | 2024-01-03 | tablet,stylus |

## Hints

<details><summary>Hint 1</summary>

`COLLECT_LIST(DISTINCT ...)` gathers values from multiple rows into an array while deduplicating. In the DataFrame API the equivalent is `collect_set`, which automatically deduplicates. To ensure a deterministic array order, wrap the result with `array_sort`. The key insight is to first `EXPLODE` the comma-separated strings into individual rows before aggregating.

</details>

<details><summary>Hint 2</summary>

1. Use a subquery to `EXPLODE(SPLIT(items, ','))` so each item is its own row.
2. In the outer query, `GROUP BY user_id` and use `COLLECT_LIST(DISTINCT item)` to gather unique items.
3. To sort the resulting array alphabetically, wrap with `ARRAY_SORT(...)`.
4. Order the final result by `user_id`.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT user_id, ARRAY_SORT(COLLECT_LIST(DISTINCT item)) AS all_items
FROM (
  SELECT user_id, EXPLODE(SPLIT(items, ',')) AS item
  FROM user_purchases
)
GROUP BY user_id
ORDER BY user_id
```

</details>

## Solutions

### SQL

```sql
SELECT user_id, ARRAY_JOIN(ARRAY_SORT(COLLECT_SET(TRIM(item))), ',') AS all_items
FROM (
  SELECT user_id, EXPLODE(SPLIT(items, ',')) AS item
  FROM user_purchases
)
GROUP BY user_id
ORDER BY user_id
```

**Why it works:**
- `EXPLODE(SPLIT(items, ','))` splits comma-separated items into individual rows
- `COLLECT_SET(TRIM(item))` deduplicates items (set semantics)
- `ARRAY_SORT(...)` ensures consistent ordering
- `ARRAY_JOIN(..., ',')` converts to a string for reliable comparison

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .select("user_id", F.explode(F.split(F.col("items"), ",")).alias("item_raw"))
    .select("user_id", F.trim(F.col("item_raw")).alias("item"))
    .groupBy("user_id")
    .agg(F.array_join(F.array_sort(F.collect_set("item")), ",").alias("all_items"))
    .orderBy("user_id")
)
```

**Why it works:**
- `F.explode(F.split(...))` converts comma-separated string to individual rows
- `F.collect_set(...)` deduplicates items
- `F.array_sort(...)` ensures consistent order
- `F.array_join(..., ",")` converts to a string for comparison
