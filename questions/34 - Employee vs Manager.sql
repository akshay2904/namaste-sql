-- ======================================================================
-- 34 - Employee vs Manager
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Accenture
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/34-employee-vs-manager
-- ======================================================================

/*
You are given the table of employee details. Write an SQL to find details of employee with salary more than their manager salary but they joined the company after the manager joined.

Display employee name, salary and joining date along with their manager's salary and joining date, sort the output in ascending order of employee name.

Please note that manager id in the employee table referring to emp id of the same table.

 
Table: employee
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| emp_id       | int         |
| emp_name     | varchar(10) |
| joining_date | date        |
| salary       | int         |
| manager_id   | int         |
+--------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    e.emp_name,
    e.salary,
    e.joining_date,
    m.salary AS manager_salary,
    m.joining_date AS manager_joining_date
FROM employee e
INNER JOIN employee m ON e.manager_id = m.emp_id
WHERE e.salary > m.salary
    AND e.joining_date > m.joining_date
ORDER BY e.emp_name ASC;
```
