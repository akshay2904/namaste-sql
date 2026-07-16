# 24. Pivot Attendance by Status

**Difficulty:** medium  
**Tags:** pivot, aggregation  
**Source:** https://spark.vutrinh.net/problems/pivot_attendance

## Problem

Given a table `attendance` with columns `employee_id`, `attendance_date`, and `status` (values: `Present`, `Absent`, `Late`), pivot the data to show the **count of each status** per employee.

Return columns: `employee_id`, `Present`, `Absent`, `Late`

Order by `employee_id` ascending.

## Schema

**`attendance`**

| column | type |
|---|---|
| employee_id | INT |
| attendance_date | STRING |
| status | STRING |

## Sample Input

**`attendance`**

| employee_id | attendance_date | status |
|---|---|---|
| 1 | 2024-01-01 | Present |
| 1 | 2024-01-02 | Present |
| 1 | 2024-01-03 | Late |
| 1 | 2024-01-04 | Absent |
| 2 | 2024-01-01 | Absent |

## Hints

<details><summary>Hint 1</summary>

The data is in "long" format — one row per (employee, date, status). The goal is to turn it into "wide" format — one row per employee with a column for each status value. This transformation is called a **pivot**.

</details>

<details><summary>Hint 2</summary>

In Spark SQL use `PIVOT` inside a subquery. In the DataFrame API use `.groupBy(...).pivot(...).agg(...)`.

SQL pattern:
```sql
SELECT * FROM (SELECT employee_id, status FROM attendance)
PIVOT (COUNT(*) FOR status IN ('Present', 'Absent', 'Late'))
```

DataFrame pattern:
```python
df.groupBy("employee_id").pivot("status", ["Present", "Absent", "Late"]).count()
```

</details>

<details><summary>Hint 3</summary>

```sql
SELECT employee_id, Present, Absent, Late
FROM (
    SELECT employee_id, status FROM attendance
)
PIVOT (
    COUNT(*) FOR status IN ('Present' AS Present, 'Absent' AS Absent, 'Late' AS Late)
)
ORDER BY employee_id
```

</details>

## Solutions

### SQL

```sql
SELECT employee_id, Present, Absent, Late
FROM (
    SELECT employee_id, status FROM attendance
)
PIVOT (
    COUNT(*) FOR status IN ('Present' AS Present, 'Absent' AS Absent, 'Late' AS Late)
)
ORDER BY employee_id
```

**Why it works:**
- The inner query selects only the columns needed for the pivot
- `PIVOT` rotates distinct values of `status` into columns
- `COUNT(*)` aggregates occurrences of each status per employee
- Missing combinations default to `NULL` (no days with that status)

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .groupBy("employee_id")
    .pivot("status", ["Present", "Absent", "Late"])
    .count()
    .orderBy("employee_id")
)
```

**Why it works:**
- `.groupBy("employee_id")` groups rows per employee
- `.pivot("status", [...])` specifies the column whose values become new columns; providing the list explicitly avoids an extra scan to discover values
- `.count()` is the aggregation — counts rows matching each status per employee
