-- ======================================================================
-- 13 - Best Employee Award
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Tcs
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/13-best-employee-award
-- ======================================================================

/*
TCS wants to award employees based on number of projects completed by each individual each month.  Write an SQL to find best employee for each month along with number of projects completed by him/her in that month, display the output in descending order of number of completed projects & employee name.
Table: projects
+-------------------------+-------------+
| COLUMN_NAME             | DATA_TYPE   |
+-------------------------+-------------+
| project_id              | int         |
| employee_name           | varchar(10) |
| project_completion_date | date        |
+-------------------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_counts AS (
    SELECT
        employee_name,
        TO_CHAR(project_completion_date, 'YYYY-MM') AS completion_month,
        COUNT(project_id) AS projects_completed
    FROM projects
    GROUP BY employee_name, TO_CHAR(project_completion_date, 'YYYY-MM')
),
ranked AS (
    SELECT
        employee_name,
        completion_month,
        projects_completed,
        -- Rank employees within each month by project count (highest first)
        RANK() OVER (PARTITION BY completion_month ORDER BY projects_completed DESC) AS rnk
    FROM monthly_counts
)
SELECT
    completion_month,
    employee_name,
    projects_completed
FROM ranked
WHERE rnk = 1
ORDER BY projects_completed DESC, employee_name DESC;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    mc.completion_month,
    mc.employee_name,
    mc.projects_completed
FROM (
    -- Count projects per employee per month
    SELECT
        employee_name,
        TO_CHAR(project_completion_date, 'YYYY-MM') AS completion_month,
        COUNT(project_id) AS projects_completed
    FROM projects
    GROUP BY employee_name, TO_CHAR(project_completion_date, 'YYYY-MM')
) mc
-- Keep only rows where employee's count equals the max count for that month
WHERE mc.projects_completed = (
    SELECT MAX(sub.projects_completed)
    FROM (
        SELECT
            employee_name,
            TO_CHAR(project_completion_date, 'YYYY-MM') AS completion_month,
            COUNT(project_id) AS projects_completed
        FROM projects
        GROUP BY employee_name, TO_CHAR(project_completion_date, 'YYYY-MM')
    ) sub
    WHERE sub.completion_month = mc.completion_month
)
ORDER BY mc.projects_completed DESC, mc.employee_name DESC;
