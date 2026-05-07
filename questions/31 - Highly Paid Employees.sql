-- ======================================================================
-- 31 - Highly Paid Employees
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Microsoft
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/31-highly-paid-employees
-- ======================================================================

/*
You are given the data of employees along with their salary and department. Write an SQL to find list of employees who have salary greater than average employee salary of the company.  However, while calculating the company average salary to compare with an employee salary do not consider salaries of that employee's department, display the output in ascending order of employee ids.

 
Table: employee
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| emp_id      | int         |
| salary      | int         |
| department  | varchar(15) |
+-------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    emp_id,
    salary,
    department
FROM employee e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employee e2
    WHERE e2.department != e1.department
)
ORDER BY emp_id ASC;
```
