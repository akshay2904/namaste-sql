-- ======================================================================
-- 122 - Third Highest Salary
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/122-third-highest-salary
-- ======================================================================

/*
You are working with an employee database where each employee has a department id and a salary. Your task is to find the third highest salary in each department. If there is no third highest salary in a department, then the query should return salary as null for that department. Sort the output by department id.

Assume that none of the employees have same salary in a particular department.

 
Table: employees 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| employee_id   | int      |
| department_id | int      |
| salary        | int      |
+---------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    department_id,
    MAX(CASE WHEN salary_rank = 3 THEN salary END) AS third_highest_salary
FROM (
    SELECT 
        department_id,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
    FROM employees
) ranked_salaries
GROUP BY department_id
ORDER BY department_id;
```
