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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH emp_with_manager AS (
    SELECT 
        e.emp_name,
        e.salary       AS emp_salary,
        e.joining_date AS emp_joining_date,
        m.salary       AS mgr_salary,
        m.joining_date AS mgr_joining_date
    FROM employee e
    JOIN employee m ON e.manager_id = m.emp_id
    WHERE e.salary > m.salary          -- employee earns more than manager
      AND e.joining_date > m.joining_date  -- employee joined after manager
)
SELECT 
    emp_name,
    emp_salary,
    emp_joining_date,
    mgr_salary,
    mgr_joining_date
FROM emp_with_manager
ORDER BY emp_name ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    e.emp_name,
    e.salary       AS emp_salary,
    e.joining_date AS emp_joining_date,
    (SELECT m.salary 
     FROM employee m 
     WHERE m.emp_id = e.manager_id)  AS mgr_salary,
    (SELECT m.joining_date 
     FROM employee m 
     WHERE m.emp_id = e.manager_id)  AS mgr_joining_date
FROM employee e
WHERE e.salary > (
        SELECT m.salary 
        FROM employee m 
        WHERE m.emp_id = e.manager_id
      )
  AND e.joining_date > (
        SELECT m.joining_date 
        FROM employee m 
        WHERE m.emp_id = e.manager_id
      )
ORDER BY e.emp_name ASC;
