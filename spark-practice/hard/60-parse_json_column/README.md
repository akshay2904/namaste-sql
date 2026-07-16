# 60. Parse JSON Column

**Difficulty:** hard  
**Tags:** json, from_json, spark specific  
**Source:** https://spark.vutrinh.net/problems/parse_json_column

## Problem

Given a table `events` with columns `event_id`, `user_id`, `event_type`, and `properties`, where `properties` is a JSON string containing the keys `page`, `duration`, and `referrer`:

Parse the `properties` JSON column and extract each key as a separate column.

Return columns: `event_id`, `user_id`, `event_type`, `page`, `duration` (INT), `referrer`.

Order by `event_id` ascending.

## Schema

**`events`**

| column | type |
|---|---|
| event_id | INT |
| user_id | INT |
| event_type | STRING |
| properties | STRING |

## Sample Input

**`events`**

| event_id | user_id | event_type | properties |
|---|---|---|---|
| 1 | 101 | page_view | {"page":"home","duration":30,"referrer":"google"} |
| 2 | 102 | page_view | {"page":"about","duration":15,"referrer":"direct"} |
| 3 | 101 | click | {"page":"home","duration":5,"referrer":"google"} |
| 4 | 103 | page_view | {"page":"pricing","duration":45,"referrer":"twitter"} |
| 5 | 102 | purchase | {"page":"checkout","duration":120,"referrer":"email"} |

## Hints

<details><summary>Hint 1</summary>

When data arrives with a JSON string packed into a single column, you need to parse it before you can use individual fields. Spark provides `GET_JSON_OBJECT` in SQL and `from_json` in the DataFrame API — both let you pull structured values out of a raw JSON string without modifying the source data.

</details>

<details><summary>Hint 2</summary>

**SQL approach:** Use `GET_JSON_OBJECT(properties, '$.page')` to extract each key by its JSONPath expression. Cast `duration` to INT since `GET_JSON_OBJECT` always returns a string.

**DataFrame approach:**
1. Define a `StructType` schema matching the JSON keys: `page` (StringType), `duration` (IntegerType), `referrer` (StringType).
2. Apply `F.from_json(F.col("properties"), schema)` to parse the column into a struct.
3. Select individual fields from the struct using dot notation: `F.col("parsed.page")`.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT
    event_id,
    user_id,
    event_type,
    GET_JSON_OBJECT(properties, '$.page') AS page,
    CAST(GET_JSON_OBJECT(properties, '$.duration') AS INT) AS duration,
    GET_JSON_OBJECT(properties, '$.referrer') AS referrer
FROM events
ORDER BY event_id
```

</details>

## Solutions

### SQL

```sql
SELECT
    event_id,
    user_id,
    event_type,
    GET_JSON_OBJECT(properties, '$.page') AS page,
    CAST(GET_JSON_OBJECT(properties, '$.duration') AS INT) AS duration,
    GET_JSON_OBJECT(properties, '$.referrer') AS referrer
FROM events
ORDER BY event_id
```

**Why it works:**
- `GET_JSON_OBJECT(col, '$.key')` extracts a single value from a JSON string using JSONPath syntax
- All extracted values are strings by default; `CAST(... AS INT)` converts `duration` to the correct type
- No schema definition is needed in SQL — each field is extracted individually

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

json_schema = "struct<page:string,duration:string,referrer:string>"

result = (
    df
    .withColumn("parsed", F.from_json(F.col("properties"), json_schema))
    .select(
        "event_id", "user_id", "event_type",
        F.col("parsed.page").alias("page"),
        F.col("parsed.duration").alias("duration"),
        F.col("parsed.referrer").alias("referrer"),
    )
    .orderBy("event_id")
)
```

**Why it works:**
- `json_schema` is a DDL string defining the JSON structure — no imports needed
- `F.from_json(col, schema)` parses the JSON string into a struct column
- Dot notation (`parsed.page`) accesses struct fields
