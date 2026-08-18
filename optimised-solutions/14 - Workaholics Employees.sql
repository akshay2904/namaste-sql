-- ======================================================================
-- 14 - Workaholics Employees
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Meta
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/14-workaholics-employees
-- ======================================================================

/*
Write a query to find workaholics employees.  Workaholics employees are those who satisfy at least one of the given criterions:

 
1- Worked for more than 8 hours a day for at least 3 days in a week. 
2- worked for more than 10 hours a day for at least 2 days in a week. 
You are given the login and logout timings of all the employees for a given week. Write a SQL to find all the workaholic employees along with the criterion that they are satisfying (1,2 or both), display it in the order of increasing employee id

 
Table: employees
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| emp_id      | int       |
| login       | datetime  |
| logout      | datetime  |
+-------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_hours AS (
    -- Calculate total hours worked per employee per day
    SELECT
        emp_id,
        DATE(login) AS work_date,
        SUM(EXTRACT(EPOCH FROM (logout - login)) / 3600.0) AS hours_worked
    FROM employees
    GROUP BY emp_id, DATE(login)
),
weekly_criteria AS (
    -- Count days per employee satisfying each criterion within a week
    SELECT
        emp_id,
        DATE_TRUNC('week', work_date) AS work_week,
        COUNT(*) FILTER (WHERE hours_worked > 8)  AS days_over_8hrs,
        COUNT(*) FILTER (WHERE hours_worked > 10) AS days_over_10hrs
    FROM daily_hours
    GROUP BY emp_id, DATE_TRUNC('week', work_date)
),
workaholic_flags AS (
    SELECT
        emp_id,
        MAX(CASE WHEN days_over_8hrs >= 3  THEN 1 ELSE 0 END) AS criterion_1,
        MAX(CASE WHEN days_over_10hrs >= 2 THEN 1 ELSE 0 END) AS criterion_2
    FROM weekly_criteria
    GROUP BY emp_id
)
SELECT
    emp_id,
    CASE
        WHEN criterion_1 = 1 AND criterion_2 = 1 THEN 'Both'
        WHEN criterion_1 = 1                      THEN '1'
        WHEN criterion_2 = 1                      THEN '2'
    END AS criterion_satisfied
FROM workaholic_flags
WHERE criterion_1 = 1 OR criterion_2 = 1
ORDER BY emp_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Employees satisfying criterion 1: >8 hrs/day for at least 3 days in a week
WITH criterion1_emps AS (
    SELECT DISTINCT emp_id
    FROM (
        SELECT
            emp_id,
            DATE_TRUNC('week', DATE(login)) AS work_week,
            COUNT(*) AS qualifying_days
        FROM (
            -- daily hours per employee
            SELECT
                emp_id,
                DATE(login) AS work_date,
                DATE_TRUNC('week', DATE(login)) AS work_week,
                SUM(EXTRACT(EPOCH FROM (logout - login)) / 3600.0) AS hours_worked
            FROM employees
            GROUP BY emp_id, DATE(login)
        ) daily
        WHERE hours_worked > 8
        GROUP BY emp_id, DATE_TRUNC('week', DATE(login))
        HAVING COUNT(*) >= 3
    ) c1
),
-- Employees satisfying criterion 2: >10 hrs/day for at least 2 days in a week
criterion2_emps AS (
    SELECT DISTINCT emp_id
    FROM (
        SELECT
            emp_id,
            DATE_TRUNC('week', DATE(login)) AS work_week,
            COUNT(*) AS qualifying_days
        FROM (
            SELECT
                emp_id,
                DATE(login) AS work_date,
                DATE_TRUNC('week', DATE(login)) AS work_week,
                SUM(EXTRACT(EPOCH FROM (logout - login)) / 3600.0) AS hours_worked
            FROM employees
            GROUP BY emp_id, DATE(login)
        ) daily
        WHERE hours_worked > 10
        GROUP BY emp_id, DATE_TRUNC('week', DATE(login))
        HAVING COUNT(*) >= 2
    ) c2
),
all_workaholics AS (
    SELECT emp_id FROM criterion1_emps
    UNION
    SELECT emp_id FROM criterion2_emps
)
SELECT
    a.emp_id,
    CASE
        WHEN c1.emp_id IS NOT NULL AND c2.emp_id IS NOT NULL THEN 'Both'
        WHEN c1.emp_id IS NOT NULL                           THEN '1'
        WHEN c2.emp_id IS NOT NULL                           THEN '2'
    END AS criterion_satisfied
FROM all_workaholics a
LEFT JOIN criterion1_emps c1 ON a.emp_id = c1.emp_id
LEFT JOIN criterion2_emps c2 ON a.emp_id = c2.emp_id
ORDER BY a.emp_id;
