# 49. Mask PII Data

**Difficulty:** medium  
**Tags:** string functions, regexp_replace  
**Source:** https://spark.vutrinh.net/problems/mask_pii

## Problem

Given a table `customers` with columns `customer_id`, `name`, `email`, and `phone`, mask the PII fields as follows:

- `masked_email`: keep the first 3 characters of the local part, replace the rest with `***`, and keep the `@domain` part intact. Example: `alice@gmail.com` → `ali***@gmail.com`
- `masked_phone`: replace all but the last 4 digits with `*`. Example: `5551234567` → `******4567`

Return columns: `customer_id`, `name`, `masked_email`, `masked_phone`

Order by `customer_id` ascending.

## Schema

**`customers`**

| column | type |
|---|---|
| customer_id | INT |
| name | STRING |
| email | STRING |
| phone | STRING |

## Sample Input

**`customers`**

| customer_id | name | email | phone |
|---|---|---|---|
| 1 | Alice Johnson | alice@gmail.com | 555-123-4567 |
| 2 | Bob Smith | bob.smith@yahoo.com | 555-987-6543 |
| 3 | Carol White | carol@company.org | 555-234-5678 |
| 4 | Dave Brown | dave@hotmail.com | 555-876-5432 |
| 5 | Eve Davis | eve.davis@outlook.com | 555-345-6789 |

## Hints

<details><summary>Hint 1</summary>

Masking PII means replacing sensitive characters with a placeholder (like `*`) while keeping enough context for identification purposes (e.g., last 4 digits of a phone).

Key functions:
- `SUBSTRING(str, pos, len)` — extract part of a string (1-indexed)
- `CONCAT(...)` — join strings together
- `REGEXP_EXTRACT(str, pattern, group)` — extract a regex capture group
- `LENGTH(str)` — length of a string

</details>

<details><summary>Hint 2</summary>

**masked_email:**
1. Take the first 3 characters of the email with `SUBSTRING(email, 1, 3)`.
2. Append the literal `***@`.
3. Extract the domain using `REGEXP_EXTRACT(email, '@(.+)$', 1)`.
4. Concatenate the three parts.

**masked_phone (format: `XXX-XXX-XXXX`):**
1. The last 4 characters of the phone string are the final 4 digits.
2. Use `CONCAT('***-***-', SUBSTRING(phone, LENGTH(phone) - 3, 4))`.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT
  customer_id,
  name,
  CONCAT(SUBSTRING(email, 1, 3), '***@', REGEXP_EXTRACT(email, '@(.+)$', 1)) AS masked_email,
  CONCAT('***-***-', SUBSTRING(phone, LENGTH(phone) - 3, 4)) AS masked_phone
FROM customers
ORDER BY customer_id
```

</details>

## Solutions

### SQL

```sql
SELECT
  customer_id,
  name,
  CONCAT(SUBSTRING(email, 1, 3), '***@', REGEXP_EXTRACT(email, '@(.+)$', 1)) AS masked_email,
  CONCAT('***-***-', SUBSTRING(phone, LENGTH(phone) - 3, 4)) AS masked_phone
FROM customers
ORDER BY customer_id
```

**Why it works:**
- `SUBSTRING(email, 1, 3)` takes the first 3 characters of the local part.
- `REGEXP_EXTRACT(email, '@(.+)$', 1)` captures the domain after the `@`.
- `CONCAT(...)` assembles the masked email: `ali***@gmail.com`.
- For the phone (format `XXX-XXX-XXXX`), `SUBSTRING(phone, LENGTH(phone) - 3, 4)` extracts the last 4 digits.
- `CONCAT('***-***-', ...)` builds the masked phone: `***-***-4567`.

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .withColumn(
        "masked_email",
        F.concat(
            F.substring(F.col("email"), 1, 3),
            F.lit("***@"),
            F.regexp_extract(F.col("email"), "@(.+)$", 1),
        )
    )
    .withColumn(
        "masked_phone",
        F.concat(
            F.lit("***-***-"),
            F.substring(F.col("phone"), F.length(F.col("phone")) - 3, 4),
        )
    )
    .select("customer_id", "name", "masked_email", "masked_phone")
    .orderBy("customer_id")
)
```

**Why it works:**
- `F.substring(col, 1, 3)` extracts the first 3 characters of the email local part.
- `F.lit("***@")` inserts the mask literal.
- `F.regexp_extract(col, "@(.+)$", 1)` extracts the domain after `@`.
- `F.length(col) - 3` positions 4 chars from the end — the last 4 digits of the phone.
- `F.lit("***-***-")` prepends the mask for the phone.
