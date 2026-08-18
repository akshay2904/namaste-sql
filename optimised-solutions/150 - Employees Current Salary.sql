-- ======================================================================
-- 150 - Employees Current Salary
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Google
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/150-employees-current-salary
-- ======================================================================

/*
In your organization, each employee has a fixed joining salary recorded at the time they start. Over time, employees may receive one or more promotions, each offering a certain percentage increase to their current salary.

 

You're given two datasets:

employees :  contains each employee’s name and joining salary.

promotions:  lists all promotions that have occurred, including the promotion date and the percent increase granted during that promotion.

 

Your task is to write a SQL query to compute the current salary of every employee by applying each of their promotions increase round to 1 decimal places.
If an employee has no promotions, their current salary remains equal to the joining salary. Order the result by emp id.

 
Table: employees
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| id            | INT     |
| name          | VARCHAR |  
|joining_salary | INT     |  
+--------------+----------+Table: promotions
+----------------+----------+
| COLUMN_NAME    | DATA_TYPE|
+----------------+----------+
|emp_id          | INT      |
|promotion_date  | DATE     | 
|percent_increase| INT      |   
+--------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH promotion_multipliers AS (
    -- Compute the combined multiplier for each employee's promotions
    -- by multiplying (1 + pct/100) for each promotion
    SELECT 
        emp_id,
        EXP(SUM(LN(1.0 + percent_increase / 100.0))) AS combined_multiplier
    FROM promotions
    GROUP BY emp_id
)
SELECT 
    e.id,
    e.name,
    ROUND(e.joining_salary * COALESCE(pm.combined_multiplier, 1.0), 1) AS current_salary
FROM employees e
LEFT JOIN promotion_multipliers pm ON e.id = pm.emp_id
ORDER BY e.id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    e.id,
    e.name,
    -- If no promotions exist, return joining_salary; otherwise apply compounded multiplier
    ROUND(
        e.joining_salary * (
            SELECT COALESCE(
                EXP(SUM(LN(1.0 + p.percent_increase / 100.0))),
                1.0
            )
            FROM promotions p
            WHERE p.emp_id = e.id
        ),
        1
    ) AS current_salary
FROM employees e
ORDER BY e.id;
