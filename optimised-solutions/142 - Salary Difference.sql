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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_salaries AS (
    SELECT
        department,
        salary,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
),
top_two AS (
    SELECT
        department,
        MAX(CASE WHEN rnk = 1 THEN salary END) AS highest_salary,
        MAX(CASE WHEN rnk = 2 THEN salary END) AS second_highest_salary
    FROM ranked_salaries
    WHERE rnk <= 2
    GROUP BY department
)
SELECT
    department AS "Department Name",
    -- Returns NULL if there's no second distinct salary
    CASE
        WHEN second_highest_salary IS NULL THEN NULL
        ELSE highest_salary - second_highest_salary
    END AS "Salary Difference"
FROM top_two
ORDER BY department;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    e.department AS "Department Name",
    CASE
        -- NULL if only one distinct salary exists in the department
        WHEN (
            SELECT COUNT(DISTINCT e2.salary)
            FROM employees e2
            WHERE e2.department = e.department
        ) < 2 THEN NULL
        ELSE (
            -- Highest salary
            SELECT MAX(e3.salary)
            FROM employees e3
            WHERE e3.department = e.department
        ) - (
            -- Second highest salary (highest salary that is less than the max)
            SELECT MAX(e4.salary)
            FROM employees e4
            WHERE e4.department = e.department
              AND e4.salary < (
                  SELECT MAX(e5.salary)
                  FROM employees e5
                  WHERE e5.department = e.department
              )
        )
    END AS "Salary Difference"
FROM employees e
GROUP BY e.department
ORDER BY e.department;
