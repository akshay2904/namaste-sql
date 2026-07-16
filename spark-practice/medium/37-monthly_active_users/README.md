# 37. Monthly Active Users

**Difficulty:** medium  
**Tags:** date functions, count distinct  
**Source:** https://spark.vutrinh.net/problems/monthly_active_users

## Problem

Given a table `user_activity` with columns `user_id`, `activity_date`, and `action`, count the number of **distinct active users per month**.

Return columns: `month` (formatted as `yyyy-MM`), `active_users`

Order by `month` ascending.

## Schema

**`user_activity`**

| column | type |
|---|---|
| user_id | INT |
| activity_date | STRING |
| action | STRING |

## Sample Input

**`user_activity`**

| user_id | activity_date | action |
|---|---|---|
| 1 | 2024-01-05 | login |
| 2 | 2024-01-07 | login |
| 3 | 2024-01-10 | purchase |
| 1 | 2024-01-15 | purchase |
| 4 | 2024-01-20 | login |

## Hints

<details><summary>Hint 1</summary>

An **active user** is any user who appears at least once in the activity log for a given month. You need to extract the month from the date column, then count how many **unique** user IDs appear in each month group.

</details>

<details><summary>Hint 2</summary>

1. Use `DATE_FORMAT(activity_date, 'yyyy-MM')` to extract the year-month string.
2. Group by the resulting `month` column.
3. Use `COUNT(DISTINCT user_id)` (SQL) or `F.countDistinct("user_id")` (DataFrame) to count unique users.
4. Order the result by `month` ascending.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT DATE_FORMAT(activity_date, 'yyyy-MM') AS month,
       COUNT(DISTINCT user_id) AS active_users
FROM user_activity
GROUP BY DATE_FORMAT(activity_date, 'yyyy-MM')
ORDER BY month
```

</details>

## Solutions

### SQL

```sql
SELECT DATE_FORMAT(activity_date, 'yyyy-MM') AS month,
       COUNT(DISTINCT user_id) AS active_users
FROM user_activity
GROUP BY DATE_FORMAT(activity_date, 'yyyy-MM')
ORDER BY month
```

**Why it works:**
- `DATE_FORMAT(activity_date, 'yyyy-MM')` converts a date string into a `yyyy-MM` month key
- `COUNT(DISTINCT user_id)` counts each user only once per month, even if they had multiple activities
- `GROUP BY` on the formatted month collapses all rows in the same month

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .withColumn("month", F.date_format(F.col("activity_date"), "yyyy-MM"))
    .groupBy("month")
    .agg(F.countDistinct("user_id").alias("active_users"))
    .orderBy("month")
)
```

**Why it works:**
- `F.date_format(...)` creates a `yyyy-MM` string column for grouping
- `F.countDistinct("user_id")` counts each user_id only once per month group
- `.orderBy("month")` sorts the final result chronologically
