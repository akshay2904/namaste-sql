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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Use a LEFT JOIN to find employees who never appear as a manager_id
SELECT e.employee_id, e.name, e.manager_id
FROM employees e
LEFT JOIN employees m ON e.employee_id = m.manager_id
WHERE m.manager_id IS NULL  -- no row had this employee as their manager
  AND m.employee_id IS NULL -- confirms no match found (leaf nodes)
ORDER BY e.employee_id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Use NOT IN to exclude any employee who appears as a manager_id
SELECT employee_id, name, manager_id
FROM employees
WHERE employee_id NOT IN (
    SELECT manager_id
    FROM employees
    WHERE manager_id IS NOT NULL  -- exclude NULLs to avoid NOT IN pitfall
)
ORDER BY employee_id ASC;
