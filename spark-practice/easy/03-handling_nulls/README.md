# 3. Handling NULLs

**Difficulty:** easy  
**Tags:** null handling, coalesce  
**Source:** https://spark.vutrinh.net/problems/handling_nulls

## Problem

Given a table `employees` with columns `employee_id`, `name`, `department`, and `salary`, return all employees with their details where:

- Replace NULL `department` with `'Unknown'`
- Replace NULL `salary` with `0`
- Only return employees whose `salary` (after replacement) is greater than `0`

Return columns: `employee_id`, `name`, `department`, `salary`

Order by `employee_id` ascending.

## Schema

**`employees`**

| column | type |
|---|---|
| employee_id | INT |
| name | STRING |
| department | STRING |
| salary | INT |

## Sample Input

**`employees`**

| employee_id | name | department | salary |
|---|---|---|---|
| 1 | Alice | Engineering | 95000 |
| 2 | Bob | Marketing |  |
| 3 | Charlie |  | 72000 |
| 4 | Diana | Engineering | 88000 |
| 5 | Eve | Marketing | 61000 |

## Hints

<details><summary>Hint 1</summary>

NULL values in Spark need special handling — comparing `NULL = NULL` always returns NULL (not true). Use dedicated NULL-handling functions instead of regular comparisons.

</details>

<details><summary>Hint 2</summary>

Use `COALESCE(column, default_value)` to replace NULLs — it returns the first non-NULL value in the list.

```sql
COALESCE(department, 'Unknown')
COALESCE(salary, 0)
```

In DataFrame API: `F.coalesce(F.col("department"), F.lit("Unknown"))`

</details>

<details><summary>Hint 3</summary>

After replacing NULLs, filter out rows where salary is 0. Apply `COALESCE` in the `SELECT` first, then filter in `WHERE` or use a subquery.

```sql
SELECT employee_id, name, COALESCE(department, 'Unknown') AS department,
       COALESCE(salary, 0) AS salary
FROM employees
WHERE COALESCE(salary, 0) > 0
ORDER BY employee_id
```

</details>

## Solutions

### SQL

```sql
SELECT employee_id, name,
       COALESCE(department, 'Unknown') AS department,
       COALESCE(salary, 0) AS salary
FROM employees
WHERE COALESCE(salary, 0) > 0
ORDER BY employee_id
```

**Why it works:**
- `COALESCE(department, 'Unknown')` replaces NULL department with 'Unknown'
- `COALESCE(salary, 0)` replaces NULL salary with 0
- `WHERE COALESCE(salary, 0) > 0` filters out rows with no salary

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

result = (
    df
    .fillna({"department": "Unknown", "salary": 0})
    .filter(F.col("salary") > 0)
    .select("employee_id", "name", "department", "salary")
    .orderBy("employee_id")
)
```

**Why it works:**
- `.fillna({"department": "Unknown", "salary": 0})` replaces NULLs per column
- `.filter(F.col("salary") > 0)` removes rows with no salary
- `.select(...)` ensures correct column order
