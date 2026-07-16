# 35. Year-over-Year Revenue Growth

**Difficulty:** hard  
**Tags:** window functions, lag, year over year  
**Source:** https://spark.vutrinh.net/problems/yoy_growth

## Problem

Given a table `annual_revenue` with columns `year`, `category`, and `revenue`, compute the **year-over-year revenue growth percentage** for each category.

Formula: `(revenue - prev_year_revenue) / prev_year_revenue * 100`

Round `yoy_growth_pct` to 2 decimal places. For the first year of each category, `yoy_growth_pct` should be `NULL`.

Return columns: `category`, `year`, `revenue`, `yoy_growth_pct`

Order by `category` ascending, then `year` ascending.

## Schema

**`annual_revenue`**

| column | type |
|---|---|
| year | INT |
| category | STRING |
| revenue | INT |

## Sample Input

**`annual_revenue`**

| year | category | revenue |
|---|---|---|
| 2021 | Electronics | 500000 |
| 2022 | Electronics | 620000 |
| 2023 | Electronics | 590000 |
| 2024 | Electronics | 710000 |
| 2021 | Clothing | 280000 |

## Hints

<details><summary>Hint 1</summary>

Year-over-year growth compares each year's value against the previous year within the same category. This requires looking back one row per category — a classic use case for `LAG()` with `PARTITION BY category ORDER BY year`.

</details>

<details><summary>Hint 2</summary>

Use `LAG(revenue) OVER (PARTITION BY category ORDER BY year)` to get the previous year's revenue. Then apply the growth formula: `(revenue - lag_revenue) / lag_revenue * 100`. The first year per category produces NULL for LAG, so the growth percentage will also be NULL.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT category, year, revenue,
       ROUND(
           (revenue - LAG(revenue) OVER (PARTITION BY category ORDER BY year))
           / LAG(revenue) OVER (PARTITION BY category ORDER BY year) * 100,
           2
       ) AS yoy_growth_pct
FROM annual_revenue
ORDER BY category, year
```

</details>

## Solutions

### SQL

```sql
WITH lagged AS (
    SELECT category,
           year,
           revenue,
           LAG(revenue) OVER (PARTITION BY category ORDER BY year) AS prev_revenue
    FROM annual_revenue
)
SELECT category,
       year,
       revenue,
       ROUND((revenue - prev_revenue) / prev_revenue * 100, 2) AS yoy_growth_pct
FROM lagged
ORDER BY category, year
```

**Why it works:**
- The CTE adds `prev_revenue` via LAG — NULL for the first year per category
- Division by NULL propagates NULL, so the first year's growth is NULL automatically
- `ROUND(..., 2)` formats the growth percentage
- The CTE improves readability vs repeating the LAG expression twice

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

w = Window.partitionBy("category").orderBy("year")

result = (
    df
    .withColumn("prev_revenue", F.lag("revenue", 1).over(w))
    .withColumn(
        "yoy_growth_pct",
        F.round((F.col("revenue") - F.col("prev_revenue")) / F.col("prev_revenue") * 100, 2)
    )
    .select("category", "year", "revenue", "yoy_growth_pct")
    .orderBy("category", "year")
)
```

**Why it works:**
- `F.lag("revenue", 1).over(w)` retrieves the previous year's revenue per category
- The growth formula is computed column by column; NULL divided by anything remains NULL
- `F.round(..., 2)` rounds the result
