# 53. Consecutive Attendance Streaks

**Difficulty:** hard  
**Tags:** window functions, islands and gaps  
**Source:** https://spark.vutrinh.net/problems/consecutive_streaks

## Problem

# Consecutive Attendance Streaks

**Difficulty:** Hard
**Tags:** window functions, islands and gaps

## Background

HR wants to reward employees with the longest unbroken run of attendance. Given a daily attendance log, find each employee's **longest consecutive "Present" streak**.

## Schema

**attendance** (`fixture.csv`)

| Column | Type | Description |
|---|---|---|
| employee_id | INT | Employee identifier |
| attendance_date | STRING | Date (YYYY-MM-DD) |
| status | STRING | `Present` or `Absent` |

## Task

For each employee, find their **maximum consecutive Present streak length**.

Return: **employee_id, max_streak**
Order by: **employee_id ASC**

## Expected Output

| employee_id | max_streak |
|---|---|
| 1 | 3 |
| 2 | 4 |
| 3 | 2 |

## Notes

- Employee 1: Present Jan 1–3 (streak 3), Absent Jan 4, Present Jan 5–7 (streak 3) → max = 3
- Employee 2: Present Jan 1 (streak 1), Absent Jan 2, Present Jan 3–6 (streak 4) → max = 4
- Employee 3: Present Jan 2–3 (streak 2), Present Jan 6–7 (streak 2) → max = 2

## Sample Input

**`attendance`**

| employee_id | attendance_date | status |
|---|---|---|
| 1 | 2024-01-01 | Present |
| 1 | 2024-01-02 | Present |
| 1 | 2024-01-03 | Present |
| 1 | 2024-01-04 | Absent |
| 1 | 2024-01-05 | Present |

## Hints

<details><summary>Hint 1</summary>

# Concept: Islands and Gaps

The **islands and gaps** pattern identifies contiguous groups ("islands") of rows that satisfy a condition, separated by gaps that do not.

## The Classic Trick

For a set of consecutive dates, if you subtract a sequential row number from each date, the result is the **same constant date** for all rows within the same island.

```
date        rn    date - rn (days)
2024-01-03   1    2024-01-02        ← island A
2024-01-04   2    2024-01-02        ← island A
2024-01-05   3    2024-01-02        ← island A (streak = 3)
-- gap --
2024-01-07   4    2024-01-03        ← island B
2024-01-08   5    2024-01-03        ← island B (streak = 2)
```

Any break in consecutive dates shifts the subtracted value, creating a new group key. You can then `COUNT(*)` per group to get streak length, and `MAX` across groups per employee.

## Why it Works

`ROW_NUMBER()` increments by 1 for each row. Consecutive dates also increment by 1 day. So `date - rn` cancels out both increments, leaving a stable anchor.

</details>

<details><summary>Hint 2</summary>

# Approach

## Step-by-Step Plan

1. **Filter** rows where `status = 'Present'`.
2. **Assign a row number** per employee ordered by `attendance_date`:
   `ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY attendance_date) AS rn`
3. **Compute the group key**:
   `DATE_SUB(attendance_date, rn)` — same value for all consecutive dates in the same island.
4. **Count** rows per `(employee_id, group_key)` → streak length.
5. **Aggregate** `MAX(streak_length)` per employee.

## Pseudocode

```
present = attendance WHERE status = 'Present'

rn = ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY attendance_date)
grp = DATE_SUB(attendance_date, rn)   -- island anchor

streaks = GROUP BY employee_id, grp → COUNT(*) AS streak_len

result = GROUP BY employee_id → MAX(streak_len) AS max_streak
```

## Tips

- In Spark SQL use `DATE_SUB(attendance_date, rn)` or `attendance_date - INTERVAL rn DAYS`.
- In the DataFrame API use `F.date_sub(F.col("attendance_date"), F.col("rn"))`.

</details>

<details><summary>Hint 3</summary>

# Query Hint

## SQL Skeleton

```sql
WITH present AS (
    SELECT employee_id, attendance_date
    FROM attendance
    WHERE status = 'Present'
),
numbered AS (
    SELECT
        employee_id,
        attendance_date,
        ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY attendance_date) AS rn
    FROM present
),
islands AS (
    SELECT
        employee_id,
        DATE_SUB(attendance_date, rn) AS grp,
        COUNT(*) AS streak_len
    FROM numbered
    GROUP BY employee_id, DATE_SUB(attendance_date, rn)
)
SELECT employee_id, MAX(streak_len) AS max_streak
FROM islands
GROUP BY employee_id
ORDER BY employee_id
```

## DataFrame Skeleton

```python
w = Window.partitionBy("employee_id").orderBy("attendance_date")

present = df.filter(F.col("status") == "Present")

result = (
    present
    .withColumn("rn", F.row_number().over(w))
    .withColumn("grp", F.date_sub(F.col("attendance_date"), F.col("rn")))
    .groupBy("employee_id", "grp")
    .agg(F.count("*").alias("streak_len"))
    .groupBy("employee_id")
    .agg(F.max("streak_len").alias("max_streak"))
    .orderBy("employee_id")
)
```

</details>

## Solutions

### SQL

# Solution: SQL

```sql
WITH present AS (
    SELECT employee_id, attendance_date
    FROM attendance
    WHERE status = 'Present'
),
numbered AS (
    SELECT
        employee_id,
        attendance_date,
        ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY attendance_date) AS rn
    FROM present
),
islands AS (
    SELECT
        employee_id,
        DATE_SUB(attendance_date, rn) AS grp,
        COUNT(*) AS streak_len
    FROM numbered
    GROUP BY employee_id, DATE_SUB(attendance_date, rn)
)
SELECT
    employee_id,
    MAX(streak_len) AS max_streak
FROM islands
GROUP BY employee_id
ORDER BY employee_id
```

## Explanation

1. **`present` CTE** — restricts the dataset to Present days only.
2. **`numbered` CTE** — assigns a sequential row number per employee ordered by date. This is the "rank within island" counter.
3. **`islands` CTE** — subtracting the integer row number from the date produces the same anchor date for all consecutive days in the same run. Grouping on this anchor and counting gives each island's length.
4. **Final SELECT** — takes the maximum streak per employee.

### DataFrame API

# Solution: DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

w = Window.partitionBy("employee_id").orderBy("attendance_date")

result = (
    attendance
    .filter(F.col("status") == "Present")
    .withColumn("rn", F.row_number().over(w))
    .withColumn("grp", F.date_sub(F.col("attendance_date"), F.col("rn")))
    .groupBy("employee_id", "grp")
    .agg(F.count("*").alias("streak_len"))
    .groupBy("employee_id")
    .agg(F.max("streak_len").alias("max_streak"))
    .orderBy("employee_id")
)

result.show()
```

## Explanation

- Filter to `Present` rows only — absent days are irrelevant to streaks.
- `row_number().over(w)` numbers the present days per employee in date order.
- `date_sub(attendance_date, rn)` produces the same anchor for all days in a contiguous island (the "islands and gaps" trick).
- The first `groupBy` counts each island's size; the second finds the maximum across all islands per employee.
