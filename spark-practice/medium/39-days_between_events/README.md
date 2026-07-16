# 39. Days Between Events

**Difficulty:** medium  
**Tags:** date functions, datediff  
**Source:** https://spark.vutrinh.net/problems/days_between_events

## Problem

Given a table `user_events` with columns `event_id`, `user_id`, `event_type`, and `event_date`, compute the **number of days between each user's signup and their first purchase**.

Each user has exactly one row with `event_type = 'signup'` and one row with `event_type = 'first_purchase'`.

Return columns: `user_id`, `signup_date`, `first_purchase_date`, `days_to_purchase`

Order by `user_id` ascending.

> Hint: Use `DATEDIFF(first_purchase_date, signup_date)` or pivot both events onto the same row first, then subtract.

## Schema

**`user_events`**

| column | type |
|---|---|
| event_id | INT |
| user_id | INT |
| event_type | STRING |
| event_date | STRING |

## Sample Input

**`user_events`**

| event_id | user_id | event_type | event_date |
|---|---|---|---|
| 1 | 101 | signup | 2024-01-05 |
| 2 | 101 | first_purchase | 2024-01-19 |
| 3 | 102 | signup | 2024-01-10 |
| 4 | 102 | first_purchase | 2024-02-01 |
| 5 | 103 | signup | 2024-02-03 |

## Hints

<details><summary>Hint 1</summary>

The data is in a long format — each event is a separate row. To compute the difference between two events for the same user, you need to bring both dates onto the same row. You can do this with a self-join, conditional aggregation (`MAX(CASE WHEN ...)`), or a pivot. Once both dates are on the same row, use `DATEDIFF` to subtract them.

</details>

<details><summary>Hint 2</summary>

Use conditional aggregation to pivot the two event types into columns:

1. Group by `user_id`.
2. Use `MAX(CASE WHEN event_type = 'signup' THEN event_date END)` to get `signup_date`.
3. Use `MAX(CASE WHEN event_type = 'first_purchase' THEN event_date END)` to get `first_purchase_date`.
4. Wrap the result in an outer query and apply `DATEDIFF(first_purchase_date, signup_date)`.
5. Order by `user_id`.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT
  user_id,
  signup_date,
  first_purchase_date,
  DATEDIFF(first_purchase_date, signup_date) AS days_to_purchase
FROM (
  SELECT
    user_id,
    MAX(CASE WHEN event_type = 'signup' THEN event_date END) AS signup_date,
    MAX(CASE WHEN event_type = 'first_purchase' THEN event_date END) AS first_purchase_date
  FROM user_events
  GROUP BY user_id
) t
ORDER BY user_id
```

</details>

## Solutions

### SQL

```sql
SELECT
  user_id,
  signup_date,
  first_purchase_date,
  DATEDIFF(first_purchase_date, signup_date) AS days_to_purchase
FROM (
  SELECT
    user_id,
    MAX(CASE WHEN event_type = 'signup' THEN event_date END) AS signup_date,
    MAX(CASE WHEN event_type = 'first_purchase' THEN event_date END) AS first_purchase_date
  FROM user_events
  GROUP BY user_id
) t
ORDER BY user_id
```

**Why it works:**
- The inner query pivots the long-format table into one row per user using conditional `MAX`
- `DATEDIFF(end, start)` computes the integer number of days between two date strings
- The outer `ORDER BY user_id` sorts the final result

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

pivoted = (
    df
    .groupBy("user_id")
    .agg(
        F.max(F.when(F.col("event_type") == "signup", F.col("event_date"))).alias("signup_date"),
        F.max(F.when(F.col("event_type") == "first_purchase", F.col("event_date"))).alias("first_purchase_date"),
    )
)

result = (
    pivoted
    .withColumn("days_to_purchase", F.datediff(F.col("first_purchase_date"), F.col("signup_date")))
    .select("user_id", "signup_date", "first_purchase_date", "days_to_purchase")
    .orderBy("user_id")
)
```

**Why it works:**
- `F.when(...).otherwise(None)` inside `F.max(...)` extracts the date only for the relevant event type
- `F.datediff(end, start)` returns an integer number of days — note the argument order: end date first
- `.select(...)` ensures the output columns are in the required order
