# 18. Multi-Table Join

**Difficulty:** medium  
**Tags:** joins, aggregation  
**Source:** https://spark.vutrinh.net/problems/multi_table_join

## Problem

You have three tables: `orders`, `customers`, and `products`.

Return the **total revenue per customer** (revenue = quantity × price), along with their name and city.

Return columns: `customer_id`, `name`, `city`, `total_revenue`

Order by `total_revenue` descending.

## Schema

**`orders`**

| column | type |
|---|---|
| order_id | INT |
| customer_id | INT |
| product_id | INT |
| quantity | INT |

**`customers`**

| column | type |
|---|---|
| customer_id | INT |
| name | STRING |
| city | STRING |

**`products`**

| column | type |
|---|---|
| product_id | INT |
| product_name | STRING |
| price | INT |

## Sample Input

**`orders`**

| order_id | customer_id | product_id | quantity |
|---|---|---|---|
| 1 | 1 | 101 | 2 |
| 2 | 1 | 102 | 1 |
| 3 | 2 | 101 | 3 |
| 4 | 3 | 103 | 1 |
| 5 | 2 | 103 | 2 |

**`customers`**

| customer_id | name | city |
|---|---|---|
| 1 | Alice | New York |
| 2 | Bob | San Francisco |
| 3 | Charlie | Chicago |
| 4 | Diana | New York |

**`products`**

| product_id | product_name | price |
|---|---|---|
| 101 | Laptop | 1200 |
| 102 | Phone | 800 |
| 103 | Tablet | 500 |

## Hints

<details><summary>Hint 1</summary>

You need to combine data from three tables. Think about which columns are shared between tables — those are your **join keys**.

</details>

<details><summary>Hint 2</summary>

Join `orders` with `customers` on `customer_id`, and join `orders` with `products` on `product_id`. Then compute `quantity * price` for each order row.

</details>

<details><summary>Hint 3</summary>

After joining, group by `customer_id`, `name`, and `city`, then use `SUM(quantity * price)` to get total revenue per customer.

```sql
SELECT c.customer_id, c.name, c.city,
       SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_revenue DESC
```

</details>

## Solutions

### SQL

```sql
SELECT c.customer_id, c.name, c.city,
       SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_revenue DESC
```

**Why it works:**
- Two `JOIN`s link `orders` to `customers` and `products` using their shared keys
- `quantity * price` computes revenue per order line
- `SUM(...)` aggregates total revenue per customer
- `GROUP BY` includes all non-aggregated columns from the SELECT

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported
# All tables are available as variables: orders, customers, products

result = (
    orders
    .join(customers, on="customer_id")
    .join(products, on="product_id")
    .withColumn("revenue", F.col("quantity") * F.col("price"))
    .groupBy("customer_id", "name", "city")
    .agg(F.sum("revenue").alias("total_revenue"))
    .orderBy(F.desc("total_revenue"))
)
```

**Why it works:**
- `.join(customers, on="customer_id")` links orders to customer info
- `.join(products, on="product_id")` links to product prices
- `.withColumn("revenue", ...)` computes per-order revenue
- `.groupBy(...).agg(F.sum(...))` aggregates per customer
