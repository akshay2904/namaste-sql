# 61. Flatten Nested Structs

**Difficulty:** hard  
**Tags:** structs, getField, spark specific  
**Source:** https://spark.vutrinh.net/problems/flatten_structs

## Problem

Given a table `orders` with columns `order_id`, `customer_name`, `address`, and `items_count`, where `address` is a JSON string containing the keys `street`, `city`, and `zip`:

Extract the address fields into separate columns.

Return columns: `order_id`, `customer_name`, `street`, `city`, `zip`, `items_count`.

Order by `order_id` ascending.

## Schema

**`orders`**

| column | type |
|---|---|
| order_id | INT |
| customer_name | STRING |
| address | STRING |
| items_count | INT |

## Sample Input

**`orders`**

| order_id | customer_name | address | items_count |
|---|---|---|---|
| 1 | Alice Johnson | {"street":"123 Main St","city":"New York","zip":"10001"} | 3 |
| 2 | Bob Smith | {"street":"456 Oak Ave","city":"Chicago","zip":"60601"} | 1 |
| 3 | Carol White | {"street":"789 Pine Rd","city":"Los Angeles","zip":"90001"} | 5 |
| 4 | Dave Brown | {"street":"321 Elm St","city":"Houston","zip":"77001"} | 2 |
| 5 | Eve Davis | {"street":"654 Maple Dr","city":"Phoenix","zip":"85001"} | 4 |

## Hints

<details><summary>Hint 1</summary>

Flattening a nested structure means promoting nested fields up to the top-level row. When the nesting is stored as a JSON string, you first parse it into a Spark struct with `from_json`, then access sub-fields with dot notation or `getField`. This is a common pattern in data lake ingestion pipelines where events are stored as JSON blobs.

</details>

<details><summary>Hint 2</summary>

**SQL approach:** Use `GET_JSON_OBJECT(address, '$.street')`, `GET_JSON_OBJECT(address, '$.city')`, and `GET_JSON_OBJECT(address, '$.zip')` to extract each field.

**DataFrame approach:**
1. Define a `StructType` schema: `street`, `city`, `zip` (all StringType).
2. Use `F.from_json(F.col("address"), schema)` to parse the JSON column into a struct named `addr`.
3. In `.select(...)`, reference the sub-fields as `F.col("addr.street")`, `F.col("addr.city")`, `F.col("addr.zip")`.
4. Preserve `order_id`, `customer_name`, and `items_count` from the original row.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT
    order_id,
    customer_name,
    GET_JSON_OBJECT(address, '$.street') AS street,
    GET_JSON_OBJECT(address, '$.city') AS city,
    GET_JSON_OBJECT(address, '$.zip') AS zip,
    items_count
FROM orders
ORDER BY order_id
```

</details>

## Solutions

### SQL

```sql
SELECT
    order_id,
    customer_name,
    GET_JSON_OBJECT(address, '$.street') AS street,
    GET_JSON_OBJECT(address, '$.city') AS city,
    GET_JSON_OBJECT(address, '$.zip') AS zip,
    items_count
FROM orders
ORDER BY order_id
```

**Why it works:**
- `GET_JSON_OBJECT` uses JSONPath (`$.key`) to extract each field from the JSON string
- The original columns (`order_id`, `customer_name`, `items_count`) are passed through unchanged
- All extracted address fields are strings, so no casting is required here

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

json_schema = "struct<street:string,city:string,zip:string>"

result = (
    df
    .withColumn("addr", F.from_json(F.col("address"), json_schema))
    .select(
        "order_id", "customer_name",
        F.col("addr.street").alias("street"),
        F.col("addr.city").alias("city"),
        F.col("addr.zip").alias("zip"),
        "items_count",
    )
    .orderBy("order_id")
)
```

**Why it works:**
- DDL schema string defines the JSON structure without any imports
- `F.from_json` parses the address JSON into a struct column
- Dot notation accesses nested struct fields
