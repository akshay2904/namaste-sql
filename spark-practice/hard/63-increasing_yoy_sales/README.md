# 63. Products with Increasing YoY Sales

**Difficulty:** hard  
**Tags:** window functions, lag, year over year  
**Source:** https://spark.vutrinh.net/problems/increasing_yoy_sales

## Problem

Given a table `product_sales` with columns `product_id`, `product_name`, `year`, and `total_sales`, find all products that had **consistently increasing sales every year** from 2021 to 2024.

A product qualifies if its sales increased in every single year-over-year comparison (2021→2022, 2022→2023, and 2023→2024 must all be positive growth).

Return columns: `product_id`, `product_name`.

Order by `product_id` ascending.

## Schema

**`product_sales`**

| column | type |
|---|---|
| product_id | INT |
| product_name | STRING |
| year | INT |
| total_sales | INT |

## Sample Input

**`product_sales`**

| product_id | product_name | year | total_sales |
|---|---|---|---|
| 1 | Widget Alpha | 2021 | 10000 |
| 1 | Widget Alpha | 2022 | 12000 |
| 1 | Widget Alpha | 2023 | 14500 |
| 1 | Widget Alpha | 2024 | 17000 |
| 2 | Gadget Beta | 2021 | 8000 |

## Hints

<details><summary>Hint 1</summary>

Year-over-year growth analysis identifies trends in time-series data. Using the LAG window function, you can compare each year's value to the previous year within the same product partition. A product qualifies as "consistently growing" only if every single YoY comparison is positive — even one flat or declining year disqualifies it.

</details>

<details><summary>Hint 2</summary>

1. Use `LAG(total_sales) OVER (PARTITION BY product_id ORDER BY year)` to get the previous year's sales.
2. Compute `yoy_growth = total_sales - prev_sales` for each row.
3. Filter out the first year (where `prev_sales` is NULL — no prior year to compare).
4. Group by `product_id` and `product_name`, then take `MIN(yoy_growth)`.
5. Keep only products where `MIN(yoy_growth) > 0` — this guarantees all YoY comparisons were positive.
6. Order by `product_id`.

</details>

<details><summary>Hint 3</summary>

```sql
WITH yoy AS (
    SELECT
        product_id,
        product_name,
        total_sales - LAG(total_sales) OVER (PARTITION BY product_id ORDER BY year) AS yoy_growth
    FROM product_sales
)
SELECT product_id, product_name
FROM yoy
WHERE yoy_growth IS NOT NULL
GROUP BY product_id, product_name
HAVING MIN(yoy_growth) > 0
ORDER BY product_id
```

</details>

## Solutions

### SQL

```sql
WITH yoy AS (
    SELECT
        product_id,
        product_name,
        total_sales - LAG(total_sales) OVER (PARTITION BY product_id ORDER BY year) AS yoy_growth
    FROM product_sales
)
SELECT product_id, product_name
FROM yoy
WHERE yoy_growth IS NOT NULL
GROUP BY product_id, product_name
HAVING MIN(yoy_growth) > 0
ORDER BY product_id
```

**Why it works:**
- `LAG(total_sales) OVER (PARTITION BY product_id ORDER BY year)` returns the previous year's sales within each product group
- Subtracting it from the current year's sales gives the raw growth; NULL for the first year (no prior row)
- `WHERE yoy_growth IS NOT NULL` excludes the first year row which has no comparison
- `HAVING MIN(yoy_growth) > 0` ensures every single YoY comparison was strictly positive — one flat or down year disqualifies the product

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

w = Window.partitionBy("product_id").orderBy("year")

result = (
    df
    .withColumn("prev_sales", F.lag("total_sales").over(w))
    .withColumn("yoy_growth", F.col("total_sales") - F.col("prev_sales"))
    .filter(F.col("prev_sales").isNotNull())
    .groupBy("product_id", "product_name")
    .agg(F.min("yoy_growth").alias("min_growth"))
    .filter(F.col("min_growth") > 0)
    .select("product_id", "product_name")
    .orderBy("product_id")
)
```

**Why it works:**
- `F.lag("total_sales").over(w)` retrieves the prior year's sales for each product; NULL for the first year
- `.filter(F.col("prev_sales").isNotNull())` removes the first-year rows before aggregation
- `F.min("yoy_growth")` finds the worst YoY performance across all years for each product
- `.filter(F.col("min_growth") > 0)` keeps only products where even the smallest YoY change was positive
