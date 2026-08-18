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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_salaries AS (
    SELECT
        department_id,
        salary,
        DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rnk
    FROM employees
),
all_depts AS (
    SELECT DISTINCT department_id FROM employees
)
SELECT
    ad.department_id,
    rs.salary AS third_highest_salary
FROM all_depts ad
LEFT JOIN ranked_salaries rs
    ON ad.department_id = rs.department_id
    AND rs.rnk = 3
ORDER BY ad.department_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    d.department_id,
    (
        -- For each department, find the salary that has exactly 2 salaries greater than it
        SELECT e.salary
        FROM employees e
        WHERE e.department_id = d.department_id
          AND (
              SELECT COUNT(DISTINCT e2.salary)
              FROM employees e2
              WHERE e2.department_id = d.department_id
                AND e2.salary > e.salary
          ) = 2
        LIMIT 1
    ) AS third_highest_salary
FROM (
    SELECT DISTINCT department_id FROM employees
) d
ORDER BY d.department_id;
