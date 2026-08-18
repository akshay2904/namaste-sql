-- ======================================================================
-- 125 - Project Budget
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Tiger analytics
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/125-project-budget
-- ======================================================================

/*
You are tasked with managing project budgets at a company. Each project has a fixed budget, and multiple employees work on these projects. The company's payroll is based on annual salaries, and each employee works for a specific duration on a project.

 

Over budget on a project is defined when the salaries (allocated on per day basis as per project duration) exceed the budget of the project. For example, if Ankit and Rohit both combined income make 200K and work on a project of a budget of 50K that takes half a year, then the project is over budget given 0.5 * 200K = 100K > 50K.

 

Write a query to forecast the budget for all projects and return a label of "overbudget" if it is over budget and "within budget" otherwise. Order the result by project title.

 Note: Assume that employees only work on one project at a time.

 
Table: employees 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| name        | varchar  |
| salary      | int      |
+-------------+----------+Table: projects 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| title       | varchar  |
| start_date  | date     |
| end_date    | date     |
| budget      | int      |
+-------------+----------+Table: project_employees 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| project_id  | int      |
| employee_id | int      |
+-------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH project_costs AS (
    SELECT
        p.id,
        p.title,
        p.budget,
        -- Calculate duration in days divided by 365 to get fraction of year
        (p.end_date - p.start_date) / 365.0 AS duration_years,
        -- Sum all salaries for employees on this project
        SUM(e.salary) AS total_salary
    FROM projects p
    JOIN project_employees pe ON p.id = pe.project_id
    JOIN employees e ON pe.employee_id = e.id
    GROUP BY p.id, p.title, p.budget, p.start_date, p.end_date
)
SELECT
    title,
    CASE
        WHEN duration_years * total_salary > budget THEN 'overbudget'
        ELSE 'within budget'
    END AS budget_status
FROM project_costs
ORDER BY title;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    p.title,
    CASE
        WHEN (
            -- Calculate allocated cost: fraction_of_year * sum_of_salaries
            ((p.end_date - p.start_date) / 365.0) *
            (
                SELECT SUM(e.salary)
                FROM project_employees pe
                JOIN employees e ON pe.employee_id = e.id
                WHERE pe.project_id = p.id
            )
        ) > p.budget
        THEN 'overbudget'
        ELSE 'within budget'
    END AS budget_status
FROM projects p
ORDER BY p.title;
