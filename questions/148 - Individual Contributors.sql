-- ======================================================================
-- 148 - Individual Contributors
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Paypal
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/148-individual-contributors
-- ======================================================================

/*
You are given a table named employees with the following structure:

 
Table: employees
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| employee_id  | INT      |
| name         | VARCHAR  |  
| manager_id   | INT      |
+--------------+----------+
Each row represents an employee. The manager_id column references the employee_id of their manager. The top-level manager(s) (e.g., CEO) will have NULL as their manager_id.

Write a SQL query to find employees who do not manage any other employees, ordered in ascending order of employee id.
*/


-- Write your SQL solution below:

```sql
SELECT e.employee_id, e.name
FROM employees e
WHERE e.employee_id NOT IN (
  SELECT DISTINCT manager_id
  FROM employees
  WHERE manager_id IS NOT NULL
)
ORDER BY e.employee_id ASC;
```
