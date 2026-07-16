# 32. Employee Salary vs Department Average

**Difficulty:** medium  
**Tags:** window functions, avg over partition  
**Source:** https://spark.vutrinh.net/problems/salary_vs_dept_avg

## Problem

Given a table `employees` with columns `employee_id`, `name`, `department`, and `salary`, show each employee's salary alongside their **department average salary** and the **difference** between their salary and the department average.

Round `dept_avg_salary` and `diff_from_avg` to 2 decimal places.

Return columns: `employee_id`, `name`, `department`, `salary`, `dept_avg_salary`, `diff_from_avg`

Order by `department` ascending, then `employee_id` ascending.

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
| 2 | Bob | Engineering | 85000 |
| 3 | Carol | Engineering | 105000 |
| 4 | Dave | Marketing | 72000 |
| 5 | Eve | Marketing | 68000 |

## Hints

<details><summary>Hint 1</summary>

Unlike `GROUP BY` which collapses rows, a window function with `PARTITION BY` computes an aggregate per group but **keeps every row**. This is exactly what you need when you want to show both individual values and a group-level statistic on the same row.

</details>

<details><summary>Hint 2</summary>

Use `AVG(salary) OVER (PARTITION BY department)` to compute the department average on each row without collapsing rows. Then subtract the average from the individual salary to get the difference.

</details>

<details><summary>Hint 3</summary>

```sql
SELECT employee_id, name, department, salary,
       ROUND(AVG(salary) OVER (PARTITION BY department), 2) AS dept_avg_salary,
       ROUND(salary - AVG(salary) OVER (PARTITION BY department), 2) AS diff_from_avg
FROM employees
ORDER BY department, employee_id
```

</details>

## Solutions

### SQL

```sql
SELECT employee_id,
       name,
       department,
       salary,
       ROUND(AVG(salary) OVER (PARTITION BY department), 2) AS dept_avg_salary,
       ROUND(salary - AVG(salary) OVER (PARTITION BY department), 2) AS diff_from_avg
FROM employees
ORDER BY department, employee_id
```

**Why it works:**
- `AVG(salary) OVER (PARTITION BY department)` computes the average within each department without reducing rows
- Each row retains its original salary alongside the department-level average
- Subtracting the two gives the difference; positive means above average, negative means below

### DataFrame API

```python
# F (pyspark.sql.functions) and Window are pre-imported

w = Window.partitionBy("department")

result = (
    df
    .withColumn("dept_avg_salary", F.round(F.avg("salary").over(w), 2))
    .withColumn("diff_from_avg", F.round(F.col("salary") - F.avg("salary").over(w), 2))
    .select("employee_id", "name", "department", "salary", "dept_avg_salary", "diff_from_avg")
    .orderBy("department", "employee_id")
)
```

**Why it works:**
- `Window.partitionBy("department")` groups rows by department without an ORDER BY (no ranking needed here)
- `F.avg("salary").over(w)` computes the department average for each row
- Two `withColumn` calls add the derived columns before the final select
