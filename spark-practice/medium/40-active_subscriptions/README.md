# 40. Active Subscriptions on a Date

**Difficulty:** medium  
**Tags:** date functions, date range  
**Source:** https://spark.vutrinh.net/problems/active_subscriptions

## Problem

Given a table `subscriptions` with columns `sub_id`, `customer_id`, `start_date`, `end_date`, and `plan`, find all subscriptions that were **active on 2024-06-15**.

A subscription is active on a given date if `start_date <= '2024-06-15' AND end_date >= '2024-06-15'`.

Return columns: `sub_id`, `customer_id`, `plan`, `start_date`, `end_date`

Order by `sub_id` ascending.

## Schema

**`subscriptions`**

| column | type |
|---|---|
| sub_id | INT |
| customer_id | INT |
| start_date | STRING |
| end_date | STRING |
| plan | STRING |

## Sample Input

**`subscriptions`**

| sub_id | customer_id | start_date | end_date | plan |
|---|---|---|---|---|
| 1 | 201 | 2024-01-01 | 2024-12-31 | annual |
| 2 | 202 | 2024-03-15 | 2024-09-14 | semi-annual |
| 3 | 203 | 2024-05-01 | 2024-07-31 | quarterly |
| 4 | 204 | 2024-06-01 | 2024-08-31 | quarterly |
| 5 | 205 | 2024-06-15 | 2024-09-15 | quarterly |

## Hints

<details><summary>Hint 1</summary>

A subscription is active on a specific date if that date falls within its start and end range (inclusive on both ends). Since dates are stored as ISO 8601 strings (`yyyy-MM-dd`), string comparison works correctly — lexicographic order matches chronological order for this format.

</details>

<details><summary>Hint 2</summary>

1. Filter the `subscriptions` table with two conditions joined by `AND`:
   - `start_date <= '2024-06-15'`
   - `end_date >= '2024-06-15'`
2. Select only the required columns: `sub_id`, `customer_id`, `plan`, `start_date`, `end_date`.
3. Order by `sub_id` ascending.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT sub_id, customer_id, plan, start_date, end_date
FROM subscriptions
WHERE start_date <= '2024-06-15'
  AND end_date >= '2024-06-15'
ORDER BY sub_id
```

</details>

## Solutions

### SQL

```sql
SELECT sub_id, customer_id, plan, start_date, end_date
FROM subscriptions
WHERE start_date <= '2024-06-15'
  AND end_date >= '2024-06-15'
ORDER BY sub_id
```

**Why it works:**
- ISO 8601 date strings sort lexicographically the same as chronologically, so string comparison is valid here
- `start_date <= '2024-06-15'` ensures the subscription had already started
- `end_date >= '2024-06-15'` ensures the subscription had not yet expired
- Both conditions together select only subscriptions that overlap the target date

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

target_date = "2024-06-15"

result = (
    df
    .filter(
        (F.col("start_date") <= target_date) &
        (F.col("end_date") >= target_date)
    )
    .select("sub_id", "customer_id", "plan", "start_date", "end_date")
    .orderBy("sub_id")
)
```

**Why it works:**
- String comparison on `yyyy-MM-dd` format is equivalent to date comparison
- `&` combines both filter conditions (use parentheses around each condition)
- `.select(...)` returns only the required columns in the specified order
