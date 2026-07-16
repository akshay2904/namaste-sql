# 23. First and Last Event per User

**Difficulty:** medium  
**Tags:** aggregation, min max  
**Source:** https://spark.vutrinh.net/problems/first_last_event

## Problem

Given a table `user_events` with columns `event_id`, `user_id`, `event_date`, and `event_type`, find the **first event date**, **last event date**, and **total number of events** for each user.

Return columns: `user_id`, `first_event`, `last_event`, `total_events`

Order by `user_id` ascending.

## Schema

**`user_events`**

| column | type |
|---|---|
| event_id | INT |
| user_id | INT |
| event_date | STRING |
| event_type | STRING |

## Sample Input

**`user_events`**

| event_id | user_id | event_date | event_type |
|---|---|---|---|
| 1 | 101 | 2024-01-05 | click |
| 2 | 102 | 2024-01-03 | view |
| 3 | 103 | 2024-01-07 | purchase |
| 4 | 101 | 2024-01-10 | purchase |
| 5 | 102 | 2024-01-08 | click |

## Hints

<details><summary>Hint 1</summary>

Group by `user_id` and use aggregate functions to find the chronological boundaries of each user's activity. Since dates are stored as strings in ISO format (YYYY-MM-DD), lexicographic MIN/MAX gives correct chronological order.

</details>

<details><summary>Hint 2</summary>

`MIN(event_date)` returns the earliest date, `MAX(event_date)` returns the latest date, and `COUNT(*)` gives total events — all within a single `GROUP BY user_id`.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT user_id,
       MIN(event_date) AS first_event,
       MAX(event_date) AS last_event,
       COUNT(*) AS total_events
FROM user_events
GROUP BY user_id
ORDER BY user_id
```

</details>

## Solutions

### SQL

```sql
SELECT user_id,
       MIN(event_date) AS first_event,
       MAX(event_date) AS last_event,
       COUNT(*) AS total_events
FROM user_events
GROUP BY user_id
ORDER BY user_id
```

**Why it works:**
- `GROUP BY user_id` produces one row per user
- `MIN(event_date)` finds the earliest date in the group
- `MAX(event_date)` finds the latest date in the group
- `COUNT(*)` tallies all events for that user

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .groupBy("user_id")
    .agg(
        F.min("event_date").alias("first_event"),
        F.max("event_date").alias("last_event"),
        F.count("*").alias("total_events")
    )
    .orderBy("user_id")
)
```

**Why it works:**
- `.groupBy("user_id")` groups all rows per user
- `F.min` and `F.max` find the date boundaries within each group
- `F.count("*")` counts all rows in the group
