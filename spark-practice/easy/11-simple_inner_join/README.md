# 11. Simple Inner Join

**Difficulty:** easy  
**Tags:** joins, filtering  
**Source:** https://spark.vutrinh.net/problems/simple_inner_join

## Problem

Given two tables `orders` and `customers`, return all **completed orders** with the customer's name and city.

Return columns: `order_id`, `name`, `city`, `amount`

Order by `order_id` ascending.

## Schema

**`orders`**

| column | type |
|---|---|
| order_id | INT |
| customer_id | INT |
| amount | INT |
| status | STRING |

**`customers`**

| column | type |
|---|---|
| customer_id | INT |
| name | STRING |
| city | STRING |

## Sample Input

**`orders`**

| order_id | customer_id | amount | status |
|---|---|---|---|
| 1 | 1 | 500 | completed |
| 2 | 2 | 800 | completed |
| 3 | 3 | 300 | pending |
| 4 | 1 | 650 | completed |
| 5 | 4 | 900 | completed |

**`customers`**

| customer_id | name | city |
|---|---|---|
| 1 | Alice | New York |
| 2 | Bob | London |
| 3 | Charlie | Paris |
| 4 | Diana | Berlin |
| 5 | Eve | Tokyo |

## Hints

<details><summary>Hint 1</summary>

A JOIN combines rows from two tables based on a matching column. An **INNER JOIN** only returns rows where there is a match in both tables.

</details>

<details><summary>Hint 2</summary>

Join on the shared key `customer_id`:

```sql
SELECT o.order_id, c.name, c.city, o.amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
```

</details>

<details><summary>Hint 3</summary>

Add `WHERE o.status = 'completed'` to filter only completed orders after joining.

</details>

## Solutions

### SQL

```sql
SELECT o.order_id, c.name, c.city, o.amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
ORDER BY o.order_id
```

**Why it works:**
- `JOIN customers c ON o.customer_id = c.customer_id` links orders to their customer
- `WHERE o.status = 'completed'` filters out pending and cancelled orders
- Note: customer Eve (id=5) has no orders so she doesn't appear — that's INNER JOIN behavior

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported
# orders and customers are available as variables

result = (
    orders
    .filter(F.col("status") == "completed")
    .join(customers, on="customer_id")
    .select("order_id", "name", "city", "amount")
    .orderBy("order_id")
)
```

**Why it works:**
- Filter before joining for better performance — reduces rows before the join
- `.join(customers, on="customer_id")` performs an inner join by default
- `.select(...)` picks only the required columns
