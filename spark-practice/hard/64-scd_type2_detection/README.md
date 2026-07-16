# 64. Slowly Changing Dimension Type 2

**Difficulty:** hard  
**Tags:** window functions, scd, data warehousing  
**Source:** https://spark.vutrinh.net/problems/scd_type2_detection

## Problem

Given a table `employee_history` with columns `record_id`, `employee_id`, `name`, `department`, `salary`, and `effective_date`, implement a **Slowly Changing Dimension Type 2** transformation.

For each record add:
- `end_date` — the `effective_date` of the next record for that employee (ordered by `effective_date`), or `NULL` if it is the most recent record
- `is_current` — `1` if `end_date` is NULL (the current active record), `0` otherwise

Return columns: `record_id`, `employee_id`, `name`, `department`, `salary`, `effective_date`, `end_date`, `is_current`.

Order by `employee_id` ascending, then `effective_date` ascending.

## Schema

**`employee_history`**

| column | type |
|---|---|
| record_id | INT |
| employee_id | INT |
| name | STRING |
| department | STRING |
| salary | INT |
| effective_date | STRING |

## Sample Input

**`employee_history`**

| record_id | employee_id | name | department | salary | effective_date |
|---|---|---|---|---|---|
| 1 | 101 | Alice Chen | Engineering | 80000 | 2022-01-01 |
| 2 | 101 | Alice Chen | Engineering | 85000 | 2022-07-01 |
| 3 | 101 | Alice Chen | Data Science | 90000 | 2023-01-01 |
| 4 | 102 | Bob Kim | Marketing | 70000 | 2022-03-01 |
| 5 | 102 | Bob Kim | Marketing | 73000 | 2022-09-01 |

## Hints

<details><summary>Hint 1</summary>

Slowly Changing Dimension Type 2 (SCD2) is a data warehousing pattern that tracks the full history of changes to dimension records. Each change creates a new row with a start date, and the previous row gets an end date set to the new row's start date. The row with a NULL end date is the current active record. This preserves complete audit history while allowing point-in-time lookups.

</details>

<details><summary>Hint 2</summary>

1. Use `LEAD(effective_date) OVER (PARTITION BY employee_id ORDER BY effective_date)` to look ahead to the next record's start date — this becomes the current record's `end_date`.
2. When `LEAD` returns NULL (no next row), the record is the most recent one for that employee.
3. Derive `is_current` with `CASE WHEN end_date IS NULL THEN 1 ELSE 0 END`.
4. Order the result by `employee_id`, then `effective_date`.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT
    record_id,
    employee_id,
    name,
    department,
    salary,
    effective_date,
    LEAD(effective_date) OVER (PARTITION BY employee_id ORDER BY effective_date) AS end_date,
    CASE WHEN LEAD(effective_date) OVER (PARTITION BY employee_id ORDER BY effective_date) IS NULL
         THEN 1 ELSE 0 END AS is_current
FROM employee_history
ORDER BY employee_id, effective_date
```

</details>

## Solutions

### SQL

```sql
SELECT
    record_id,
    employee_id,
    name,
    department,
    salary,
    effective_date,
    LEAD(effective_date) OVER (PARTITION BY employee_id ORDER BY effective_date) AS end_date,
    CASE
        WHEN LEAD(effective_date) OVER (PARTITION BY employee_id ORDER BY effective_date) IS NULL
        THEN 1
        ELSE 0
    END AS is_current
FROM employee_history
ORDER BY employee_id, effective_date
```

**Why it works:**
- `LEAD(effective_date) OVER (PARTITION BY employee_id ORDER BY effective_date)` peeks at the next row's start date within each employee group — this becomes the current row's `end_date`
- When there is no next row (the most recent record), `LEAD` returns NULL, indicating the record is still active
- The `CASE WHEN` translates the NULL into the `is_current = 1` flag
- No self-join is needed — the entire logic is expressed with a single window function pass

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

w = Window.partitionBy("employee_id").orderBy("effective_date")

result = (
    df
    .withColumn("end_date", F.lead("effective_date").over(w))
    .withColumn("is_current", F.when(F.col("end_date").isNull(), 1).otherwise(0))
    .select(
        "record_id",
        "employee_id",
        "name",
        "department",
        "salary",
        "effective_date",
        "end_date",
        "is_current",
    )
    .orderBy("employee_id", "effective_date")
)
```

**Why it works:**
- `F.lead("effective_date").over(w)` reads the next row's `effective_date` within the employee partition, ordered chronologically
- The last record per employee gets NULL from `F.lead` — there is no following row
- `F.when(F.col("end_date").isNull(), 1).otherwise(0)` converts the NULL into a binary `is_current` flag
- The explicit `.select(...)` ensures column order matches the expected output exactly
