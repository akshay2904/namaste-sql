# 51. Standardize Phone Numbers

**Difficulty:** medium  
**Tags:** regexp_replace, string functions  
**Source:** https://spark.vutrinh.net/problems/standardize_phones

## Problem

Given a table `contacts` with columns `contact_id`, `name`, and `phone`, standardize all phone numbers to the format `XXX-XXX-XXXX`.

Phone numbers may appear in any of these formats:
- `(555) 123-4567`
- `555-123-4567`
- `5551234567`
- `555.123.4567`

All source phones contain exactly 10 digits.

Steps:
1. Strip all non-digit characters to get a 10-digit string.
2. Format as `XXX-XXX-XXXX` using the first 3, next 3, and last 4 digits.

Return columns: `contact_id`, `name`, `original_phone`, `standardized_phone`

Order by `contact_id` ascending.

## Schema

**`contacts`**

| column | type |
|---|---|
| contact_id | INT |
| name | STRING |
| phone | STRING |

## Sample Input

**`contacts`**

| contact_id | name | phone |
|---|---|---|
| 1 | Alice Johnson | (555) 123-4567 |
| 2 | Bob Smith | 555-234-5678 |
| 3 | Carol White | 5553456789 |
| 4 | Dave Brown | 555.456.7890 |
| 5 | Eve Davis | (555) 567-8901 |

## Hints

<details><summary>Hint 1</summary>

Phone numbers often arrive in inconsistent formats. Standardizing them requires:
1. Stripping non-digit characters to isolate the raw digits.
2. Reassembling the digits into the target format using string slicing.

Key functions:
- `REGEXP_REPLACE(str, pattern, replacement)` — replace all matches of a regex
- `SUBSTRING(str, pos, len)` — extract a substring (1-indexed)
- `CONCAT(...)` — join multiple strings

</details>

<details><summary>Hint 2</summary>

1. Use `REGEXP_REPLACE(phone, '[^0-9]', '')` to strip everything except digits. Store the result as `digits`.
2. All phones have exactly 10 digits, so:
   - Area code: `SUBSTRING(digits, 1, 3)`
   - Exchange: `SUBSTRING(digits, 4, 3)`
   - Number: `SUBSTRING(digits, 7, 4)`
3. `CONCAT(area, '-', exchange, '-', number)` produces `XXX-XXX-XXXX`.
4. Keep the original `phone` column aliased as `original_phone`.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT
  contact_id,
  name,
  phone AS original_phone,
  CONCAT(
    SUBSTRING(digits, 1, 3), '-',
    SUBSTRING(digits, 4, 3), '-',
    SUBSTRING(digits, 7, 4)
  ) AS standardized_phone
FROM (
  SELECT *, REGEXP_REPLACE(phone, '[^0-9]', '') AS digits
  FROM contacts
)
ORDER BY contact_id
```

</details>

## Solutions

### SQL

```sql
SELECT
  contact_id,
  name,
  phone AS original_phone,
  CONCAT(
    SUBSTRING(digits, 1, 3), '-',
    SUBSTRING(digits, 4, 3), '-',
    SUBSTRING(digits, 7, 4)
  ) AS standardized_phone
FROM (
  SELECT *, REGEXP_REPLACE(phone, '[^0-9]', '') AS digits
  FROM contacts
)
ORDER BY contact_id
```

**Why it works:**
- The inner query uses `REGEXP_REPLACE(phone, '[^0-9]', '')` to strip every non-digit character, leaving exactly 10 digits in `digits`.
- `SUBSTRING(digits, 1, 3)` — first 3 digits (area code).
- `SUBSTRING(digits, 4, 3)` — next 3 digits (exchange).
- `SUBSTRING(digits, 7, 4)` — final 4 digits (subscriber number).
- `CONCAT(...)` assembles them with `-` separators into `XXX-XXX-XXXX`.

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .withColumn("original_phone", F.col("phone"))
    .withColumn("digits", F.regexp_replace(F.col("phone"), "[^0-9]", ""))
    .withColumn(
        "standardized_phone",
        F.concat(
            F.substring(F.col("digits"), 1, 3),
            F.lit("-"),
            F.substring(F.col("digits"), 4, 3),
            F.lit("-"),
            F.substring(F.col("digits"), 7, 4),
        )
    )
    .select("contact_id", "name", "original_phone", "standardized_phone")
    .orderBy("contact_id")
)
```

**Why it works:**
- `F.regexp_replace(col, "[^0-9]", "")` removes all non-digit characters, leaving a clean 10-digit string.
- `F.substring(col, 1, 3)` / `(col, 4, 3)` / `(col, 7, 4)` slices the three groups of digits (Spark uses 1-based indexing).
- `F.lit("-")` inserts the literal dash separator.
- `F.concat(...)` assembles everything into `XXX-XXX-XXXX`.
