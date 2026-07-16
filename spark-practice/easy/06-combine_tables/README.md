# 6. Combine Two Tables

**Difficulty:** easy  
**Tags:** union, set operations  
**Source:** https://spark.vutrinh.net/problems/combine_tables

## Problem

You have two tables of orders from different years: `orders_2023` and `orders_2024`, both with columns `order_id`, `customer_id`, `amount`, and `year`.

Combine both tables into a single result and return **all orders** sorted by `order_id` ascending.

Return columns: `order_id`, `customer_id`, `amount`, `year`

## Schema

**`orders_2023`**

| column | type |
|---|---|
| order_id | INT |
| customer_id | INT |
| amount | INT |
| year | INT |

**`orders_2024`**

| column | type |
|---|---|
| order_id | INT |
| customer_id | INT |
| amount | INT |
| year | INT |

## Sample Input

**`orders_2023`**

| order_id | customer_id | amount | year |
|---|---|---|---|
| 1 | 101 | 500 | 2023 |
| 2 | 102 | 800 | 2023 |
| 3 | 103 | 300 | 2023 |
| 4 | 101 | 650 | 2023 |

**`orders_2024`**

| order_id | customer_id | amount | year |
|---|---|---|---|
| 5 | 102 | 900 | 2024 |
| 6 | 104 | 450 | 2024 |
| 7 | 101 | 700 | 2024 |
| 8 | 105 | 1200 | 2024 |

## Hints

<details><summary>Hint 1</summary>

When you need to stack rows from two tables with the same schema, use a **set operation** — not a join. Joins combine columns; unions combine rows.

</details>

<details><summary>Hint 2</summary>

Use `UNION ALL` to combine both tables — `UNION ALL` keeps all rows including duplicates (which is correct here since each order is unique).

In DataFrame API: `.union()` or `.unionByName()` — prefer `unionByName` when column order might differ.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT * FROM orders_2023
UNION ALL
SELECT * FROM orders_2024
ORDER BY order_id
```

</details>

## Solutions

### SQL

```sql
SELECT * FROM orders_2023
UNION ALL
SELECT * FROM orders_2024
ORDER BY order_id
```

**Why it works:**
- `UNION ALL` stacks rows from both tables without removing duplicates
- `UNION` (without ALL) would deduplicate — not what we want here since all orders are unique
- `ORDER BY order_id` sorts the combined result

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported
# orders_2023 and orders_2024 are available as variables

result = (
    orders_2023
    .unionByName(orders_2024)
    .orderBy("order_id")
)
```

**Why it works:**
- `.unionByName()` stacks rows matching columns by name, not position — safer than `.union()`
- `.orderBy("order_id")` sorts the combined result
