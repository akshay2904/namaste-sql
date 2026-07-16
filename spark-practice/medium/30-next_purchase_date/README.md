# 30. Next Purchase Date

**Difficulty:** medium  
**Tags:** window functions, lead  
**Source:** https://spark.vutrinh.net/problems/next_purchase_date

## Problem

Given a table `purchases` with columns `purchase_id`, `customer_id`, `purchase_date`, and `amount`, find the **next purchase date** for each purchase by the same customer.

If there is no subsequent purchase by the customer, `next_purchase_date` should be `NULL`.

Return columns: `purchase_id`, `customer_id`, `purchase_date`, `next_purchase_date`

Order by `customer_id` ascending, then `purchase_date` ascending.

## Schema

**`purchases`**

| column | type |
|---|---|
| purchase_id | INT |
| customer_id | INT |
| purchase_date | STRING |
| amount | INT |

## Sample Input

**`purchases`**

| purchase_id | customer_id | purchase_date | amount |
|---|---|---|---|
| 1 | 101 | 2024-01-05 | 120 |
| 2 | 102 | 2024-01-03 | 200 |
| 3 | 101 | 2024-01-12 | 85 |
| 4 | 103 | 2024-01-07 | 310 |
| 5 | 102 | 2024-01-15 | 150 |

## Hints

<details><summary>Hint 1</summary>

`LEAD()` is the forward-looking counterpart of `LAG()`. While `LAG()` looks backward at the previous row, `LEAD()` looks forward at the next row within the window partition.

</details>

<details><summary>Hint 2</summary>

Partition by `customer_id` so each customer's purchases are processed independently, order by `purchase_date` chronologically, then use `LEAD(purchase_date, 1)` to get the next date. The last purchase per customer returns NULL.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT purchase_id, customer_id, purchase_date,
       LEAD(purchase_date) OVER (PARTITION BY customer_id ORDER BY purchase_date) AS next_purchase_date
FROM purchases
ORDER BY customer_id, purchase_date
```

</details>

## Solutions

### SQL

```sql
SELECT purchase_id,
       customer_id,
       purchase_date,
       LEAD(purchase_date) OVER (PARTITION BY customer_id ORDER BY purchase_date) AS next_purchase_date
FROM purchases
ORDER BY customer_id, purchase_date
```

**Why it works:**
- `PARTITION BY customer_id` keeps each customer's rows in an isolated window
- `ORDER BY purchase_date` arranges rows chronologically within each partition
- `LEAD(purchase_date)` returns the value from the next row; returns NULL for the last row in each partition

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

w = Window.partitionBy("customer_id").orderBy("purchase_date")

result = (
    df
    .withColumn("next_purchase_date", F.lead("purchase_date", 1).over(w))
    .select("purchase_id", "customer_id", "purchase_date", "next_purchase_date")
    .orderBy("customer_id", "purchase_date")
)
```

**Why it works:**
- `Window.partitionBy("customer_id").orderBy("purchase_date")` defines the per-customer chronological window
- `F.lead("purchase_date", 1).over(w)` fetches the next row's purchase date
- The last purchase per customer returns NULL automatically
