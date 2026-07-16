# 12. Customers with No Orders

**Difficulty:** medium  
**Tags:** joins, anti-join, left join  
**Source:** https://spark.vutrinh.net/problems/customers_no_orders

## Problem

Given tables `customers` and `orders`, find all customers who have **never placed an order**.

Return columns: `customer_id`, `name`, `city`, `signup_date`

Order by `customer_id` ascending.

## Schema

**`customers`**

| column | type |
|---|---|
| customer_id | INT |
| name | STRING |
| city | STRING |
| signup_date | STRING |

**`orders`**

| column | type |
|---|---|
| order_id | INT |
| customer_id | INT |
| amount | INT |

## Sample Input

**`customers`**

| customer_id | name | city | signup_date |
|---|---|---|---|
| 1 | Alice | New York | 2023-01-15 |
| 2 | Bob | London | 2023-02-20 |
| 3 | Charlie | Paris | 2023-03-10 |
| 4 | Diana | Berlin | 2023-04-05 |
| 5 | Eve | Tokyo | 2023-05-12 |

**`orders`**

| order_id | customer_id | amount |
|---|---|---|
| 1 | 1 | 500 |
| 2 | 2 | 800 |
| 3 | 1 | 300 |
| 4 | 3 | 650 |
| 5 | 2 | 900 |

## Hints

<details><summary>Hint 1</summary>

This is an **anti-join** — finding rows in one table that have no match in another. You can't do this with a regular INNER JOIN since that only returns matches.

</details>

<details><summary>Hint 2</summary>

Use a `LEFT JOIN` — it keeps all rows from the left table (customers) even if there's no match in the right table (orders). Unmatched rows get NULL for all order columns.

</details>

<details><summary>Hint 3</summary>

After the LEFT JOIN, filter where `order_id IS NULL` — these are the customers with no matching order:

```sql
SELECT c.customer_id, c.name, c.city, c.signup_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id
```

</details>

## Solutions

### SQL

```sql
SELECT c.customer_id, c.name, c.city, c.signup_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id
```

**Why it works:**
- `LEFT JOIN` keeps all customers, filling NULL for order columns when no match exists
- `WHERE o.order_id IS NULL` keeps only customers with no matching order — the anti-join pattern

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported
# customers and orders are available as variables

result = (
    customers
    .join(orders, on="customer_id", how="left")
    .filter(F.col("order_id").isNull())
    .select("customer_id", "name", "city", "signup_date")
    .orderBy("customer_id")
)
```

**Why it works:**
- `how="left"` keeps all customers even without matching orders
- `.filter(F.col("order_id").isNull())` — the anti-join filter
- Spark also supports `how="left_anti"` which does this in one step: `.join(orders, on="customer_id", how="left_anti")`
