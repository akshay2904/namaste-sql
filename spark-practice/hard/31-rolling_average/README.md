# 31. 7-Day Rolling Average

**Difficulty:** hard  
**Tags:** window functions, rolling, rows between  
**Source:** https://spark.vutrinh.net/problems/rolling_average

## Problem

Given a table `daily_sales` with columns `sale_date` and `amount`, compute the **7-day rolling average** of daily sales. The rolling average for each day covers the current day and the 6 preceding days.

Round `rolling_avg_7d` to 2 decimal places.

Return columns: `sale_date`, `amount`, `rolling_avg_7d`

Order by `sale_date` ascending.

## Schema

**`daily_sales`**

| column | type |
|---|---|
| sale_date | STRING |
| amount | INT |

## Sample Input

**`daily_sales`**

| sale_date | amount |
|---|---|
| 2024-01-01 | 120 |
| 2024-01-02 | 95 |
| 2024-01-03 | 150 |
| 2024-01-04 | 110 |
| 2024-01-05 | 180 |

## Hints

<details><summary>Hint 1</summary>

A rolling (or sliding) window aggregation computes an aggregate over a fixed-size window of rows that moves as you progress through the data. The window frame `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW` captures exactly 7 rows: the current row plus 6 before it.

</details>

<details><summary>Hint 2</summary>

Use `AVG(amount) OVER (ORDER BY sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)`. For the first 6 days, the window is smaller than 7 rows — Spark computes the average over however many rows are available (this is fine and expected behavior).

</details>

<details><summary>Hint 3</summary>

```sql
SELECT sale_date, amount,
       ROUND(AVG(amount) OVER (ORDER BY sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS rolling_avg_7d
FROM daily_sales
ORDER BY sale_date
```

</details>

## Solutions

### SQL

```sql
SELECT sale_date,
       amount,
       ROUND(AVG(amount) OVER (ORDER BY sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS rolling_avg_7d
FROM daily_sales
ORDER BY sale_date
```

**Why it works:**
- `ORDER BY sale_date` orders rows chronologically within the window
- `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW` defines a physical frame of up to 7 rows
- `AVG(amount)` over that frame computes the rolling average
- `ROUND(..., 2)` rounds to 2 decimal places
- For the first 6 days, the window shrinks to whatever rows are available

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

w = Window.orderBy("sale_date").rowsBetween(-6, 0)

result = (
    df
    .withColumn("rolling_avg_7d", F.round(F.avg("amount").over(w), 2))
    .select("sale_date", "amount", "rolling_avg_7d")
    .orderBy("sale_date")
)
```

**Why it works:**
- `.rowsBetween(-6, 0)` is the Python equivalent of `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW`
- `F.avg("amount").over(w)` computes the average over the sliding 7-row frame
- `F.round(..., 2)` rounds the result to 2 decimal places
