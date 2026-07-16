# 48. Extract Email Domain

**Difficulty:** medium  
**Tags:** string functions, regexp_extract  
**Source:** https://spark.vutrinh.net/problems/extract_email_domain

## Problem

Given a table `users` with columns `user_id`, `name`, and `email`, extract the domain portion of each email address (everything after the `@`).

Return columns: `user_id`, `name`, `email`, `domain`

Order by `user_id` ascending.

## Schema

**`users`**

| column | type |
|---|---|
| user_id | INT |
| name | STRING |
| email | STRING |

## Sample Input

**`users`**

| user_id | name | email |
|---|---|---|
| 1 | Alice Johnson | alice@gmail.com |
| 2 | Bob Smith | bob.smith@yahoo.com |
| 3 | Carol White | carol@company.org |
| 4 | Dave Brown | dave@hotmail.com |
| 5 | Eve Davis | eve.davis@outlook.com |

## Hints

<details><summary>Hint 1</summary>

`REGEXP_EXTRACT(str, pattern, group)` returns the captured group from the first regex match in a string. The pattern `@(.+)$` matches the `@` sign and captures everything after it until end of string. Group index `1` returns the first capture group — the domain.

</details>

<details><summary>Hint 2</summary>

1. Use `REGEXP_EXTRACT` with the pattern `@(.+)$` to capture the domain part of the email.
2. The capture group index is `1` — this returns everything after the `@`.
3. Alias the result as `domain` and select all required columns.
4. Order by `user_id`.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT user_id, name, email, REGEXP_EXTRACT(email, '@(.+)$', 1) AS domain
FROM users
ORDER BY user_id
```

</details>

## Solutions

### SQL

```sql
SELECT user_id, name, email, REGEXP_EXTRACT(email, '@(.+)$', 1) AS domain
FROM users
ORDER BY user_id
```

**Why it works:**
- `REGEXP_EXTRACT(email, '@(.+)$', 1)` applies the regex `@(.+)$` to the `email` column.
- The `@` matches the literal at-sign; `(.+)$` captures one or more characters until end of string — the domain.
- Capture group index `1` returns just the domain portion without the `@`.

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .withColumn("domain", F.regexp_extract(F.col("email"), "@(.+)$", 1))
    .select("user_id", "name", "email", "domain")
    .orderBy("user_id")
)
```

**Why it works:**
- `F.regexp_extract(col, pattern, groupIndex)` extracts the matched group from the regex.
- Pattern `@(.+)$` captures everything after the `@` symbol.
- `groupIndex=1` returns the first (and only) capture group — the domain.
