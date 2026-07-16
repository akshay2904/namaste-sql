# 36. Top Customers by Region

**Difficulty:** hard  
**Tags:** window functions, rank, nested partition  
**Source:** https://spark.vutrinh.net/problems/top_customers_region

## Problem

Given a table `customers` with columns `customer_id`, `name`, `region`, and `total_spend`, find the **top 2 customers by total spend in each region**.

Return columns: `region`, `customer_id`, `name`, `total_spend`, `rank`

Order by `region` ascending, then `rank` ascending.

## Schema

**`customers`**

| column | type |
|---|---|
| customer_id | INT |
| name | STRING |
| region | STRING |
| total_spend | INT |

## Sample Input

**`customers`**

| customer_id | name | region | total_spend |
|---|---|---|---|
| 1 | Alice | North | 4500 |
| 2 | Bob | North | 7200 |
| 3 | Carol | North | 3100 |
| 4 | Dave | North | 8900 |
| 5 | Eve | North | 6300 |

## Hints

<details><summary>Hint 1</summary>

The "top N per group" pattern requires two steps: first assign a rank within each group using a window function, then filter to keep only rows where rank <= N. You cannot filter on a window function result in the same SELECT — use a subquery or CTE.

</details>

<details><summary>Hint 2</summary>

Use `RANK() OVER (PARTITION BY region ORDER BY total_spend DESC)` to rank customers within each region. Wrap that in a CTE or subquery, then filter `WHERE rank <= 2`. Using `RANK()` means tied spends get the same rank — if two customers tie for rank 1, both are included and no rank-2 row exists.

</details>

<details><summary>Hint 3</summary>

```sql
WITH ranked AS (
    SELECT region, customer_id, name, total_spend,
           RANK() OVER (PARTITION BY region ORDER BY total_spend DESC) AS rank
    FROM customers
)
SELECT region, customer_id, name, total_spend, rank
FROM ranked
WHERE rank <= 2
ORDER BY region, rank
```

</details>

## Solutions

### SQL

```sql
WITH ranked AS (
    SELECT region,
           customer_id,
           name,
           total_spend,
           RANK() OVER (PARTITION BY region ORDER BY total_spend DESC) AS rank
    FROM customers
)
SELECT region, customer_id, name, total_spend, rank
FROM ranked
WHERE rank <= 2
ORDER BY region, rank
```

**Why it works:**
- The CTE assigns a rank within each region, 1 being the highest spender
- `WHERE rank <= 2` keeps only the top 2 customers per region
- Window function results cannot be filtered in the same query level — a CTE or subquery is required
- `ORDER BY region, rank` gives a clean region-by-region view of the top customers

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

w = Window.partitionBy("region").orderBy(F.col("total_spend").desc())

result = (
    df
    .withColumn("rank", F.rank().over(w))
    .filter(F.col("rank") <= 2)
    .select("region", "customer_id", "name", "total_spend", "rank")
    .orderBy("region", "rank")
)
```

**Why it works:**
- `F.rank().over(w)` assigns ranks within each region by descending spend
- `.filter(F.col("rank") <= 2)` keeps only the top 2 per region
- In the DataFrame API, filtering on a window column works directly (unlike SQL where a subquery is needed)
