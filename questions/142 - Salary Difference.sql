-- ======================================================================
-- 142 - Salary Difference
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Linkedin
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/142-salary-difference
-- ======================================================================

/*
You are given an employees table containing information about employees' salaries across different departments. Your task is to calculate the difference between the highest and second-highest salaries for each department.

Conditions:
If a department has only one employee, return NULL for that department.
If all employees in a department have the same salary, return NULL for that department.

The final output should include Department Name and Salary Difference. Order by Department Name.

Table: employees
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| name        | VARCHAR  | 
| department  | VARCHAR  | 
| salary      | int      | 
+-------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    e.department,
    CASE 
        WHEN COUNT(DISTINCT e.salary) < 2 THEN NULL
        ELSE MAX(e.salary) - (
            SELECT MAX(salary) 
            FROM employees e2 
            WHERE e2.department = e.department 
            AND salary < (SELECT MAX(salary) FROM employees e3 WHERE e3.department = e.department)
        )
    END AS salary_difference
FROM employees e
GROUP BY e.department
ORDER BY e.department;
```
