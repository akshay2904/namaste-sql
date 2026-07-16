# 9. String Basics

**Difficulty:** easy  
**Tags:** string functions, data cleaning  
**Source:** https://spark.vutrinh.net/problems/string_basics

## Problem

Given a table `customers` with columns `customer_id`, `first_name`, `last_name`, `email`, and `city`, clean and format the data:

- `full_name` = trimmed first name + `' '` + trimmed last name, in **Title Case**
- `email` = lowercased and trimmed
- `city` = **Title Case** (e.g. `new york` → `New York`)

Return columns: `customer_id`, `full_name`, `email`, `city`

Order by `customer_id` ascending.

## Schema

**`customers`**

| column | type |
|---|---|
| customer_id | INT |
| first_name | STRING |
| last_name | STRING |
| email | STRING |
| city | STRING |

## Sample Input

**`customers`**

| customer_id | first_name | last_name | email | city |
|---|---|---|---|---|
| 1 |   alice   | Smith | alice@example.com | new york |
| 2 | BOB | johnson | BOB@EXAMPLE.COM |   London |
| 3 | Charlie |   BROWN   | charlie@example.com | paris |
| 4 | diana | Williams | diana@example.com | BERLIN |
| 5 |   EVE   | Davis | eve@example.com | tokyo |

## Hints

<details><summary>Hint 1</summary>

Real-world data is messy — names have extra spaces, inconsistent casing, mixed formats. String functions let you clean and standardize data before analysis.

</details>

<details><summary>Hint 2</summary>

Key functions:
- `TRIM(col)` — removes leading/trailing spaces
- `LOWER(col)` — converts to lowercase
- `INITCAP(col)` — Title Case (first letter of each word capitalized) — Spark-specific!
- `CONCAT(a, ' ', b)` — concatenates strings

</details>

<details><summary>Hint 3</summary>

`INITCAP` handles Title Case for you — no need to manually capitalize:

```sql
SELECT customer_id,
       INITCAP(CONCAT(TRIM(first_name), ' ', TRIM(last_name))) AS full_name,
       LOWER(TRIM(email)) AS email,
       INITCAP(TRIM(city)) AS city
FROM customers
ORDER BY customer_id
```

</details>

## Solutions

### SQL

```sql
SELECT customer_id,
       INITCAP(CONCAT(TRIM(first_name), ' ', TRIM(last_name))) AS full_name,
       LOWER(TRIM(email)) AS email,
       INITCAP(TRIM(city)) AS city
FROM customers
ORDER BY customer_id
```

**Why it works:**
- `TRIM()` removes leading/trailing whitespace
- `CONCAT(..., ' ', ...)` joins first and last name with a space
- `INITCAP()` applies Title Case — a Spark SQL function not available in all SQL dialects
- `LOWER()` lowercases the email

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .withColumn("full_name", F.initcap(F.concat(F.trim(F.col("first_name")), F.lit(" "), F.trim(F.col("last_name")))))
    .withColumn("email", F.lower(F.trim(F.col("email"))))
    .withColumn("city", F.initcap(F.trim(F.col("city"))))
    .select("customer_id", "full_name", "email", "city")
    .orderBy("customer_id")
)
```

**Why it works:**
- `F.trim()` removes whitespace
- `F.concat()` joins strings; `F.lit(" ")` is a literal space character
- `F.initcap()` applies Title Case
- `F.lower()` lowercases the email
