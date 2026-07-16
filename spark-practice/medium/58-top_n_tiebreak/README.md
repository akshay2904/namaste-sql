# 58. Top N with Tie-Breaking

**Difficulty:** medium  
**Tags:** window functions, row_number, tie-breaking  
**Source:** https://spark.vutrinh.net/problems/top_n_tiebreak

## Problem

# Top N with Tie-Breaking

**Difficulty:** Medium
**Tags:** window functions, row_number, tie-breaking

## Background

HR wants the top 2 earners from each department for the annual bonus review. When two employees earn the same salary, the one with the lower `employee_id` gets the higher rank (seniority tie-break).

## Schema

**employees** (`fixture.csv`)

| Column | Type | Description |
|---|---|---|
| employee_id | INT | Unique employee identifier |
| name | STRING | Employee name |
| department | STRING | Department |
| salary | INT | Annual salary in USD |

## Task

Get the **top 2 earners per department**, breaking ties by `employee_id ASC`. Use `ROW_NUMBER` (not `RANK`) so exactly 2 rows are returned per department regardless of ties.

Return: **department, employee_id, name, salary, row_num**
Order by: **department ASC, row_num ASC**

## Expected Output

| department | employee_id | name | salary | row_num |
|---|---|---|---|---|
| Engineering | 1 | Alice | 95000 | 1 |
| Engineering | 3 | Carol | 95000 | 2 |
| Finance | 9 | Iris | 110000 | 1 |
| Finance | 10 | Jack | 98000 | 2 |
| Marketing | 5 | Eve | 70000 | 1 |
| Marketing | 6 | Frank | 70000 | 2 |

## Notes

- Engineering: Alice (id=1, 95k) and Carol (id=3, 95k) are tied — Alice wins on lower id.
- Finance: Iris (110k) first, then Jack (id=10, 98k) before Karen (id=11, 98k).
- Marketing: Eve (id=5, 70k) and Frank (id=6, 70k) both at 70k — Eve wins.

## Sample Input

**`employees`**

| employee_id | name | department | salary |
|---|---|---|---|
| 1 | Alice | Engineering | 95000 |
| 2 | Bob | Engineering | 88000 |
| 3 | Carol | Engineering | 95000 |
| 4 | Dave | Engineering | 72000 |
| 5 | Eve | Marketing | 70000 |

## Hints

<details><summary>Hint 1</summary>

# Concept: ROW_NUMBER for Top-N with Deterministic Tie-Breaking

## Why ROW_NUMBER, not RANK?

| Function | Behaviour on ties | Rows returned per group |
|---|---|---|
| `RANK` | Tied rows share a rank; next rank skips | May exceed N |
| `DENSE_RANK` | Tied rows share a rank; no skip | May exceed N |
| `ROW_NUMBER` | Every row gets a unique number arbitrarily within ties | Exactly N |

When you need **exactly N rows per group** regardless of ties, use `ROW_NUMBER`. To make the result **deterministic**, you must supply a fully-defined `ORDER BY` that resolves all ties — here, `salary DESC, employee_id ASC`.

## Fully-Defined ORDER BY

```sql
ROW_NUMBER() OVER (
    PARTITION BY department
    ORDER BY salary DESC, employee_id ASC
)
```

- Primary sort: `salary DESC` — highest earner first.
- Tiebreaker: `employee_id ASC` — among equal salaries, the employee hired first (lower id) gets the lower row number.

With both criteria, no two rows within a partition share the same `(salary, employee_id)` pair, so `ROW_NUMBER` is completely deterministic.

</details>

<details><summary>Hint 2</summary>

# Approach

## Step-by-Step Plan

1. **Define the window**: partition by `department`, order by `salary DESC, employee_id ASC`.
2. **Apply `ROW_NUMBER()`** over the window → `row_num`.
3. **Filter** to `row_num <= 2`.
4. **Select** `department, employee_id, name, salary, row_num`.
5. **Order** by `department ASC, row_num ASC`.

## Pseudocode

```
w = PARTITION BY department ORDER BY salary DESC, employee_id ASC

df = employees
    .withColumn("row_num", ROW_NUMBER().over(w))
    .filter(row_num <= 2)
    .select(department, employee_id, name, salary, row_num)
    .orderBy(department, row_num)
```

## Common Mistakes

- Using `RANK` or `DENSE_RANK` — these can return more than 2 rows per department when there are ties.
- Forgetting `employee_id` in the `ORDER BY` — without it, results are non-deterministic for tied salaries.

</details>

<details><summary>Hint 3</summary>

# Query Hint

## SQL Skeleton

```sql
WITH ranked AS (
    SELECT
        department,
        employee_id,
        name,
        salary,
        ROW_NUMBER() OVER (
            PARTITION BY department
            ORDER BY salary DESC, employee_id ASC
        ) AS row_num
    FROM employees
)
SELECT department, employee_id, name, salary, row_num
FROM ranked
WHERE row_num <= 2
ORDER BY department, row_num
```

## DataFrame Skeleton

```python
w = Window.partitionBy("department").orderBy(
    F.col("salary").desc(), F.col("employee_id").asc()
)

result = (
    df.withColumn("row_num", F.row_number().over(w))
      .filter(F.col("row_num") <= 2)
      .select("department", "employee_id", "name", "salary", "row_num")
      .orderBy("department", "row_num")
)
```

</details>

## Solutions

### SQL

# Solution: SQL

```sql
WITH ranked AS (
    SELECT
        department,
        employee_id,
        name,
        salary,
        ROW_NUMBER() OVER (
            PARTITION BY department
            ORDER BY salary DESC, employee_id ASC
        ) AS row_num
    FROM employees
)
SELECT
    department,
    employee_id,
    name,
    salary,
    row_num
FROM ranked
WHERE row_num <= 2
ORDER BY department, row_num
```

## Explanation

1. **`ranked` CTE** — assigns a unique row number to every employee within their department. The ordering `salary DESC, employee_id ASC` puts the highest earner first and uses the lower employee ID as a deterministic tiebreaker for equal salaries.
2. **`WHERE row_num <= 2`** — retains only the top 2 employees per department. Because `ROW_NUMBER` never produces duplicates, exactly 2 rows per department pass the filter.
3. **`ORDER BY department, row_num`** — presents results department by department, with rank 1 before rank 2.

### DataFrame API

# Solution: DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

w = Window.partitionBy("department").orderBy(
    F.col("salary").desc(),
    F.col("employee_id").asc(),
)

result = (
    employees
    .withColumn("row_num", F.row_number().over(w))
    .filter(F.col("row_num") <= 2)
    .select("department", "employee_id", "name", "salary", "row_num")
    .orderBy("department", "row_num")
)

result.show()
```

## Explanation

- The window is partitioned by `department` and ordered by `salary DESC, employee_id ASC`, fully resolving any ties.
- `row_number()` assigns 1, 2, 3, ... to employees within each department — no ties, no gaps.
- Filtering `row_num <= 2` keeps exactly the top two earners per department.
- `select` and `orderBy` produce the clean, deterministic output required.
