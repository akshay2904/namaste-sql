# 22. Count Distinct Users per Day

**Difficulty:** medium  
**Tags:** aggregation, count distinct  
**Source:** https://spark.vutrinh.net/problems/count_distinct_day

## Problem

Given a table `user_events` with columns `event_id`, `user_id`, `event_date`, and `event_type`, count the number of **distinct users** and **total events** for each day.

Return columns: `event_date`, `distinct_users`, `total_events`

Order by `event_date` ascending.

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
| 1 | 101 | 2024-01-01 | click |
| 2 | 102 | 2024-01-01 | view |
| 3 | 101 | 2024-01-01 | purchase |
| 4 | 103 | 2024-01-02 | click |
| 5 | 101 | 2024-01-02 | view |

## Hints

<details><summary>Hint 1</summary>

Use `GROUP BY event_date` to collapse all events into one row per day. You need two different aggregations: one for distinct users and one for total events.

</details>

<details><summary>Hint 2</summary>

`COUNT(*)` counts all rows (total events). To count unique users only, use `COUNT(DISTINCT user_id)` — this de-duplicates users who triggered multiple events on the same day.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT event_date,
       COUNT(DISTINCT user_id) AS distinct_users,
       COUNT(*) AS total_events
FROM user_events
GROUP BY event_date
ORDER BY event_date
```

</details>

## Solutions

### SQL

```sql
SELECT event_date,
       COUNT(DISTINCT user_id) AS distinct_users,
       COUNT(*) AS total_events
FROM user_events
GROUP BY event_date
ORDER BY event_date
```

**Why it works:**
- `GROUP BY event_date` produces one row per day
- `COUNT(DISTINCT user_id)` counts each user only once per day, even if they triggered multiple events
- `COUNT(*)` counts every event row including duplicates

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .groupBy("event_date")
    .agg(
        F.countDistinct("user_id").alias("distinct_users"),
        F.count("*").alias("total_events")
    )
    .orderBy("event_date")
)
```

**Why it works:**
- `.groupBy("event_date")` groups all events by day
- `F.countDistinct("user_id")` is the DataFrame equivalent of `COUNT(DISTINCT user_id)`
- `F.count("*")` counts all rows regardless of duplicates
