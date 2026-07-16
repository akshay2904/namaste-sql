# 45. Filter Users by Interest

**Difficulty:** medium  
**Tags:** array_contains, filtering  
**Source:** https://spark.vutrinh.net/problems/filter_array

## Problem

Given a table `user_interests` with columns `user_id`, `name`, and `interests` (a comma-separated string), find all users who are interested in **'Technology'**.

Return columns: `user_id`, `name`

Order by `user_id` ascending.

> Hint: Use `ARRAY_CONTAINS(SPLIT(interests, ','), 'Technology')` to check for membership after splitting.

## Schema

**`user_interests`**

| column | type |
|---|---|
| user_id | INT |
| name | STRING |
| interests | STRING |

## Sample Input

**`user_interests`**

| user_id | name | interests |
|---|---|---|
| 1 | Alice | Technology,Sports,Music |
| 2 | Bob | Cooking,Travel |
| 3 | Carol | Technology,Art,Cooking |
| 4 | Dave | Sports,Gaming |
| 5 | Eve | Technology,Finance,Travel |

## Hints

<details><summary>Hint 1</summary>

`ARRAY_CONTAINS(array, value)` returns `true` if the value exists in the array. Since the `interests` column is a plain string, you first need to convert it to an array with `SPLIT`, then apply `ARRAY_CONTAINS` on the result.

</details>

<details><summary>Hint 2</summary>

1. In the `WHERE` clause, apply `SPLIT(interests, ',')` to get an array.
2. Wrap it in `ARRAY_CONTAINS(..., 'Technology')`.
3. Select `user_id` and `name`.
4. Order by `user_id` ascending.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT user_id, name
FROM user_interests
WHERE ARRAY_CONTAINS(SPLIT(interests, ','), 'Technology')
ORDER BY user_id
```

</details>

## Solutions

### SQL

```sql
SELECT user_id, name
FROM user_interests
WHERE ARRAY_CONTAINS(SPLIT(interests, ','), 'Technology')
ORDER BY user_id
```

**Why it works:**
- `SPLIT(interests, ',')` converts the comma-separated string into an array
- `ARRAY_CONTAINS(array, 'Technology')` checks for an exact match of the element in the array
- Only rows where the condition is true are returned
- `ORDER BY user_id` gives a deterministic result

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .filter(F.array_contains(F.split(F.col("interests"), ","), "Technology"))
    .select("user_id", "name")
    .orderBy("user_id")
)
```

**Why it works:**
- `F.split(F.col("interests"), ",")` produces an `ArrayType(StringType)` column
- `F.array_contains(array_col, value)` returns a boolean column — `True` when the value is present
- `.filter(...)` keeps only matching rows
- `.select("user_id", "name")` drops the `interests` column from the output
