-- ======================================================================
-- 202 - The Phantom Managers
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Fractal analytics
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/202-the-phantom-managers
-- ======================================================================

/*
You work at a large e-commerce company with thousands of employees spread across departments. HR maintains an employee table with each employee's manager. A "Phantom Manager" is a manager who appears in the manager_id column but has no record of their own in the employees table — meaning they exist as a manager but are ghost entries with no employee profile.

 
Table: employees (Each row is one employee. Manager is also an employee (self-referencing).
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| employee_id   | INT       |
| employee_name | VARCHAR   |
| department    | VARCHAR   |
| salary        | DECIMAL   |
| manager_id    | INT       |
+---------------+-----------+

manager_id references employee_id in the same table

Top-level employees (CEO etc.) have manager_id = NULL

A phantom manager has a manager_id value that doesn't exist as any employee_id

 

Find all phantom managers and return one row per phantom with the following:

phantom_manager_id — the ghost manager ID , result sorted by this column

affected_count — how many employees report directly to this phantom

total_salary_at_risk — sum of salaries of all affected employees

departments_affected — distinct departments of those employees, comma-separated and sorted alphabetically

 

Constraints & Traps:

manager_id = NULL is not a phantom — it means no manager (top level)

An employee can report to a phantom who in turn reports to another phantom (phantom chain) — only find direct phantoms for this question

The comma-separated lists should be alphabetically sorted.
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH phantom_managers AS (
    -- Find manager_ids that have no matching employee_id record
    SELECT DISTINCT e.manager_id AS phantom_manager_id
    FROM employees e
    WHERE e.manager_id IS NOT NULL
      AND NOT EXISTS (
          SELECT 1
          FROM employees mgr
          WHERE mgr.employee_id = e.manager_id
      )
)
SELECT
    pm.phantom_manager_id,
    COUNT(e.employee_id)                                      AS affected_count,
    SUM(e.salary)                                             AS total_salary_at_risk,
    STRING_AGG(DISTINCT e.department, ', ' ORDER BY e.department) AS departments_affected
FROM phantom_managers pm
JOIN employees e
    ON e.manager_id = pm.phantom_manager_id
GROUP BY pm.phantom_manager_id
ORDER BY pm.phantom_manager_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    e.manager_id                                                   AS phantom_manager_id,
    COUNT(e.employee_id)                                           AS affected_count,
    SUM(e.salary)                                                  AS total_salary_at_risk,
    STRING_AGG(DISTINCT e.department, ', ' ORDER BY e.department)  AS departments_affected
FROM employees e
WHERE
    -- Only non-null manager references
    e.manager_id IS NOT NULL
    -- Keep only those whose manager_id doesn't appear as a real employee
    AND e.manager_id NOT IN (
        SELECT employee_id
        FROM employees
        WHERE employee_id IS NOT NULL   -- guard against NULLs in the subquery
    )
GROUP BY e.manager_id
ORDER BY e.manager_id;
