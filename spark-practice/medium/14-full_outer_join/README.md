# 14. Full Outer Join

**Difficulty:** medium  
**Tags:** joins, full outer join, null handling  
**Source:** https://spark.vutrinh.net/problems/full_outer_join

## Problem

Given tables `employees` and `departments`, produce a **full report** showing:
- All employees (even those in departments not in the `departments` table)
- All departments (even those with no employees)

Return columns: `employee_id`, `name`, `department_id`, `department_name`, `budget`

Use `COALESCE` to fill NULL `department_id` from either table. Order by `department_id` ascending (NULLs last), then `employee_id` ascending.

## Schema

**`employees`**

| column | type |
|---|---|
| employee_id | INT |
| name | STRING |
| department_id | INT |

**`departments`**

| column | type |
|---|---|
| department_id | INT |
| department_name | STRING |
| budget | INT |

## Sample Input

**`employees`**

| employee_id | name | department_id |
|---|---|---|
| 1 | Alice | 10 |
| 2 | Bob | 20 |
| 3 | Charlie | 10 |
| 4 | Diana | 30 |
| 5 | Eve | 40 |

**`departments`**

| department_id | department_name | budget |
|---|---|---|
| 10 | Engineering | 500000 |
| 20 | Marketing | 300000 |
| 50 | Finance | 400000 |
| 60 | HR | 200000 |

## Hints

<details><summary>Hint 1</summary>

A **FULL OUTER JOIN** returns all rows from both tables — matched rows combined, unmatched rows from either side with NULLs for the missing columns. It's LEFT JOIN + RIGHT JOIN combined.

</details>

<details><summary>Hint 2</summary>

```sql
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.department_id
```

In DataFrame API: `how="outer"` or `how="full"` — both work in Spark.

</details>

<details><summary>Hint 3</summary>

After a FULL OUTER JOIN, `department_id` may come from either table. Use `COALESCE(e.department_id, d.department_id)` to get a non-NULL value when possible.

</details>

## Solutions

### SQL

```sql
SELECT e.employee_id, e.name,
       COALESCE(e.department_id, d.department_id) AS department_id,
       d.department_name, d.budget
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.department_id
ORDER BY department_id ASC NULLS LAST, e.employee_id ASC
```

**Why it works:**
- `FULL OUTER JOIN` returns all rows from both tables
- `COALESCE(e.department_id, d.department_id)` handles the case where one side is NULL
- Employees in dept 30 and 40 have no matching department — `department_name` and `budget` are NULL
- Departments 50 and 60 have no employees — `employee_id` and `name` are NULL

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported
# employees and departments are available as variables

result = (
    employees
    .join(departments, on="department_id", how="outer")
    .withColumn("department_id", F.coalesce(
        employees["department_id"], departments["department_id"]
    ))
    .select("employee_id", "name", "department_id", "department_name", "budget")
    .orderBy(F.asc_nulls_last("department_id"), F.asc_nulls_last("employee_id"))
)
```

**Why it works:**
- `how="outer"` is the full outer join
- `F.coalesce(...)` picks the non-NULL department_id from either side
- `F.asc_nulls_last(...)` — Spark-specific function to sort NULLs last
