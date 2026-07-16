# 2. Find Duplicate Emails

**Difficulty:** easy  
**Tags:** aggregation, groupby, filtering  
**Source:** https://spark.vutrinh.net/problems/find_duplicates

## Problem

Given a table `users` with columns `email`, `name`, and `signup_date`, find all **duplicate email addresses** — emails that appear more than once.

Return columns: `email`, `count`

Order by `count` descending, then `email` ascending.

## Schema

**`users`**

| column | type |
|---|---|
| email | STRING |
| name | STRING |
| signup_date | STRING |

## Sample Input

**`users`**

| email | name | signup_date |
|---|---|---|
| alice@example.com | Alice | 2024-01-01 |
| bob@example.com | Bob | 2024-01-02 |
| alice@example.com | Alice Smith | 2024-01-03 |
| charlie@example.com | Charlie | 2024-01-04 |
| bob@example.com | Bobby | 2024-01-05 |

## Hints

<details><summary>Hint 1</summary>

Think about how you can **count how many times each email appears** in the table.

</details>

<details><summary>Hint 2</summary>

Use `GROUP BY email` with `COUNT(*)` to count occurrences per email address.

</details>

<details><summary>Hint 3</summary>

Filter groups using `HAVING COUNT(*) > 1` — this keeps only emails that appear more than once.

```sql
SELECT email, COUNT(*) AS count
FROM users
GROUP BY email
HAVING COUNT(*) > 1
```

</details>

## Solutions

### SQL

```sql
SELECT email, COUNT(*) AS count
FROM users
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY count DESC, email ASC
```

**Why it works:**
- `GROUP BY email` groups all rows by email address
- `COUNT(*)` counts how many times each email appears
- `HAVING COUNT(*) > 1` filters out emails that only appear once
- `ORDER BY count DESC, email ASC` sorts by most duplicates first, then alphabetically

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = df \
    .groupBy("email") \
    .agg(F.count("*").alias("count")) \
    .filter(F.col("count") > 1) \
    .orderBy(F.desc("count"), "email")
```

**Why it works:**
- `.groupBy("email")` groups by email address
- `.agg(F.count("*").alias("count"))` counts occurrences per group
- `.filter(F.col("count") > 1)` keeps only duplicates
- `.orderBy(F.desc("count"), "email")` sorts as required
