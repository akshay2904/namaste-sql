# 13. Self Join — Find Manager

**Difficulty:** medium  
**Tags:** joins, self-join  
**Source:** https://spark.vutrinh.net/problems/self_join_manager

## Problem

Given a table `employees` where each row has an `employee_id`, `name`, `department`, and `manager_id` (which references another `employee_id`), return each employee along with their manager's name.

Employees without a manager (top-level) should have `NULL` for `manager_name`.

Return columns: `employee_id`, `name`, `department`, `manager_name`

Order by `employee_id` ascending.

## Schema

**`employees`**

| column | type |
|---|---|
| employee_id | INT |
| name | STRING |
| department | STRING |
| manager_id | INT |

## Sample Input

**`employees`**

| employee_id | name | department | manager_id |
|---|---|---|---|
| 1 | Alice | Engineering |  |
| 2 | Bob | Engineering | 1 |
| 3 | Charlie | Engineering | 1 |
| 4 | Diana | Marketing |  |
| 5 | Eve | Marketing | 4 |

## Hints

<details><summary>Hint 1</summary>

A **self-join** joins a table to itself. Here, the same `employees` table is used twice — once for the employee, once to look up their manager.

</details>

<details><summary>Hint 2</summary>

Use table aliases to distinguish the two copies of the table:

```sql
FROM employees e        -- the employee
LEFT JOIN employees m   -- the manager
ON e.manager_id = m.employee_id
```

</details>

<details><summary>Hint 3</summary>

Use `LEFT JOIN` so employees without a manager still appear (with NULL for manager_name):

```sql
SELECT e.employee_id, e.name, e.department, m.name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.employee_id
```

</details>

## Solutions

### SQL

```sql
SELECT e.employee_id, e.name, e.department, m.name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.employee_id
```

**Why it works:**
- The same table is joined to itself with two aliases: `e` (employee) and `m` (manager)
- `LEFT JOIN` ensures employees without a manager (NULL `manager_id`) still appear
- `m.name AS manager_name` picks the manager's name from the second copy

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

managers = df.select(
    F.col("employee_id").alias("manager_id"),
    F.col("name").alias("manager_name")
)

result = (
    df
    .join(managers, on="manager_id", how="left")
    .select("employee_id", "name", "department", "manager_name")
    .orderBy("employee_id")
)
```

**Why it works:**
- Create a `managers` DataFrame with just `manager_id` and `manager_name`
- Left join the original `df` on `manager_id`
- Employees without a manager get NULL for `manager_name`
