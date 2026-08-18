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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH dept_totals AS (
    -- Precompute per-department aggregates once
    SELECT
        department,
        SUM(salary) AS dept_salary_sum,
        COUNT(*)    AS dept_count
    FROM employee
    GROUP BY department
),
company_totals AS (
    SELECT
        SUM(salary) AS total_salary,
        COUNT(*)    AS total_count
    FROM employee
),
employee_avg AS (
    -- For each employee, compute average excluding their own department
    SELECT
        e.emp_id,
        e.salary,
        e.department,
        -- Subtract this dept's sum and count from company totals
        (ct.total_salary - dt.dept_salary_sum) * 1.0
            / NULLIF(ct.total_count - dt.dept_count, 0) AS avg_excl_dept
    FROM employee e
    JOIN dept_totals  dt ON e.department = dt.department
    CROSS JOIN company_totals ct
)
SELECT emp_id, salary, department
FROM employee_avg
WHERE salary > avg_excl_dept
ORDER BY emp_id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    e.emp_id,
    e.salary,
    e.department
FROM employee e
WHERE e.salary > (
    -- Average of all employees NOT in this employee's department
    SELECT AVG(CAST(e2.salary AS DECIMAL))
    FROM employee e2
    WHERE e2.department <> e.department
)
ORDER BY e.emp_id ASC;
