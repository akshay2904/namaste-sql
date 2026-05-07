-- ======================================================================
-- 159 - Department Salary Contribution
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Walmart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/159-department-salary-contribution
-- ======================================================================

/*
You are working as a data analyst for a large company that tracks employee salaries across multiple departments. The leadership team wants to understand how much each department contributes to the company’s total payroll.

Write a SQL query to calculate the percentage of total salary contributed by each department. Round the result to 2 decimal places.

 
Table: employees
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| emp_id      | INT      |
| dept_id     | INT      | 
| salary      | INT      |
+-------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    dept_id,
    SUM(salary) AS dept_total_salary,
    ROUND(
        100.0 * SUM(salary) / SUM(SUM(salary)) OVER (),
        2
    ) AS percentage_of_total
FROM employees
GROUP BY dept_id
ORDER BY percentage_of_total DESC;
```
