# 59. Cohort Retention Analysis

**Difficulty:** hard  
**Tags:** window functions, date functions, cohort  
**Source:** https://spark.vutrinh.net/problems/cohort_retention

## Problem

Given a table `user_activity` with columns `user_id`, `signup_date`, and `activity_date`, perform a **cohort retention analysis**.

Group users into cohorts based on their signup month. For each cohort, count how many distinct users were active in month 0 (signup month), month 1, month 2, and month 3 after signup.

Return columns: `cohort_month` (format `yyyy-MM`), `months_since_signup` (INT), `active_users` (INT).

Only include rows where `months_since_signup` is between 0 and 3 (inclusive).

Order by `cohort_month` ascending, then `months_since_signup` ascending.

## Schema

**`user_activity`**

| column | type |
|---|---|
| user_id | INT |
| signup_date | STRING |
| activity_date | STRING |

## Sample Input

**`user_activity`**

| user_id | signup_date | activity_date |
|---|---|---|
| 1 | 2024-01-05 | 2024-01-10 |
| 1 | 2024-01-05 | 2024-02-15 |
| 1 | 2024-01-05 | 2024-03-20 |
| 1 | 2024-01-05 | 2024-04-08 |
| 2 | 2024-01-12 | 2024-01-20 |

## Hints

<details><summary>Hint 1</summary>

Cohort retention analysis groups users by when they first joined (their signup cohort) and tracks how many remain active in subsequent time periods. The key insight is computing the distance in months between each activity event and the user's signup date — this gives you the "months since signup" dimension.

</details>

<details><summary>Hint 2</summary>

1. Use `DATE_FORMAT(signup_date, 'yyyy-MM')` to extract the cohort month for each user.
2. Use `MONTHS_BETWEEN(activity_date, signup_date)` to compute how many months after signup each activity occurred. Cast to INT to get whole months.
3. Filter to keep only rows where `months_since_signup` is between 0 and 3.
4. Group by `cohort_month` and `months_since_signup`, then count distinct users with `COUNT(DISTINCT user_id)`.
5. Order the final result by `cohort_month`, then `months_since_signup`.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT
    DATE_FORMAT(signup_date, 'yyyy-MM') AS cohort_month,
    CAST(MONTHS_BETWEEN(activity_date, signup_date) AS INT) AS months_since_signup,
    COUNT(DISTINCT user_id) AS active_users
FROM user_activity
WHERE CAST(MONTHS_BETWEEN(activity_date, signup_date) AS INT) BETWEEN 0 AND 3
GROUP BY cohort_month, months_since_signup
ORDER BY cohort_month, months_since_signup
```

</details>

## Solutions

### SQL

```sql
SELECT
    DATE_FORMAT(signup_date, 'yyyy-MM') AS cohort_month,
    CAST(MONTHS_BETWEEN(activity_date, signup_date) AS INT) AS months_since_signup,
    COUNT(DISTINCT user_id) AS active_users
FROM user_activity
WHERE CAST(MONTHS_BETWEEN(activity_date, signup_date) AS INT) BETWEEN 0 AND 3
GROUP BY
    DATE_FORMAT(signup_date, 'yyyy-MM'),
    CAST(MONTHS_BETWEEN(activity_date, signup_date) AS INT)
ORDER BY cohort_month, months_since_signup
```

**Why it works:**
- `DATE_FORMAT(signup_date, 'yyyy-MM')` truncates the signup date to month granularity, defining the cohort
- `MONTHS_BETWEEN(activity_date, signup_date)` computes the fractional months elapsed; casting to INT gives whole months
- `WHERE ... BETWEEN 0 AND 3` restricts to the 4-month retention window
- `COUNT(DISTINCT user_id)` ensures each user is counted only once per cohort/month bucket

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .withColumn("cohort_month", F.date_format(F.col("signup_date"), "yyyy-MM"))
    .withColumn(
        "months_since_signup",
        F.months_between(
            F.to_date(F.col("activity_date")),
            F.to_date(F.col("signup_date"))
        ).cast("int")
    )
    .filter((F.col("months_since_signup") >= 0) & (F.col("months_since_signup") <= 3))
    .groupBy("cohort_month", "months_since_signup")
    .agg(F.countDistinct("user_id").alias("active_users"))
    .orderBy("cohort_month", "months_since_signup")
)
```

**Why it works:**
- `F.date_format` extracts the cohort month as a `yyyy-MM` string
- `F.months_between` computes fractional months between two dates; `.cast("int")` truncates to whole months
- `F.to_date` ensures date arithmetic is performed on date types, not strings
- `F.countDistinct("user_id")` counts each user only once within a cohort/month bucket
