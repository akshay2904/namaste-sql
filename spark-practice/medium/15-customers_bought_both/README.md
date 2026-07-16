# 15. Customers Who Bought Both

**Difficulty:** medium  
**Tags:** joins, intersect, filtering  
**Source:** https://spark.vutrinh.net/problems/customers_bought_both

## Problem

Given a table `orders` with columns `order_id`, `customer_id`, and `product`, find all customers who have purchased **both** a `Laptop` and a `Phone`.

Return columns: `customer_id`

Order by `customer_id` ascending.

## Schema

**`orders`**

| column | type |
|---|---|
| order_id | INT |
| customer_id | INT |
| product | STRING |

## Sample Input

**`orders`**

| order_id | customer_id | product |
|---|---|---|
| 1 | 1 | Laptop |
| 2 | 2 | Phone |
| 3 | 1 | Phone |
| 4 | 3 | Laptop |
| 5 | 4 | Phone |

## Hints

<details><summary>Hint 1</summary>

You need customers that appear in two separate groups — those who bought a Laptop AND those who bought a Phone. Think about how to find the **intersection** of two sets of customers.

</details>

<details><summary>Hint 2</summary>

Two approaches work:

1. **INTERSECT**: Find customers who bought Laptop, then INTERSECT with customers who bought Phone
2. **GROUP BY + HAVING**: Group by customer, count distinct products matching either Laptop or Phone, keep those with count = 2

</details>

<details><summary>Hint 3</summary>

Using INTERSECT:

```sql
SELECT customer_id FROM orders WHERE product = 'Laptop'
INTERSECT
SELECT customer_id FROM orders WHERE product = 'Phone'
ORDER BY customer_id
```

Using GROUP BY + HAVING:

```sql
SELECT customer_id
FROM orders
WHERE product IN ('Laptop', 'Phone')
GROUP BY customer_id
HAVING COUNT(DISTINCT product) = 2
ORDER BY customer_id
```

</details>

## Solutions

### SQL

```sql
SELECT customer_id FROM orders WHERE product = 'Laptop'
INTERSECT
SELECT customer_id FROM orders WHERE product = 'Phone'
ORDER BY customer_id
```

**Why it works:**
- Each subquery returns the set of customers who bought that product
- `INTERSECT` keeps only customers present in both sets
- Alternative using GROUP BY + HAVING also works — both are valid Spark SQL

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

laptop_buyers = df.filter(F.col("product") == "Laptop").select("customer_id")
phone_buyers = df.filter(F.col("product") == "Phone").select("customer_id")

result = laptop_buyers.intersect(phone_buyers).orderBy("customer_id")
```

**Why it works:**
- Filter each product separately into its own DataFrame
- `.intersect()` returns only `customer_id` values present in both
