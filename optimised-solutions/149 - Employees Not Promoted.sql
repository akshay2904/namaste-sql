-- ======================================================================
-- 149 - Employees Not Promoted
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Tiger analytics
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/149-employees-not-promoted
-- ======================================================================

/*
The promotions table records all historical promotions of employees (an employee can appear multiple times).
Write a query to find all employees who were not promoted in the last 1 year from today. Display id , name and latest promotion date for those employees order by id.

 
Table: employees
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | INT      |
| name        | VARCHAR  |  
+-------------+----------+Table: promotions
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
|emp_id        | INT      |
|promotion_date| DATE     |  
+--------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH latest_promotions AS (
    SELECT
        emp_id,
        MAX(promotion_date) AS latest_promotion_date
    FROM promotions
    GROUP BY emp_id
)
SELECT
    e.id,
    e.name,
    lp.latest_promotion_date
FROM employees e
LEFT JOIN latest_promotions lp
    ON e.id = lp.emp_id
-- Include employees with no promotion at all, or last promotion > 1 year ago
WHERE lp.latest_promotion_date < CURRENT_DATE - INTERVAL '1 year'
   OR lp.latest_promotion_date IS NULL
ORDER BY e.id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    e.id,
    e.name,
    (SELECT MAX(p.promotion_date)
     FROM promotions p
     WHERE p.emp_id = e.id) AS latest_promotion_date
FROM employees e
WHERE e.id NOT IN (
    -- Exclude employees who had a promotion within the last 1 year
    SELECT emp_id
    FROM promotions
    WHERE promotion_date >= CURRENT_DATE - INTERVAL '1 year'
)
ORDER BY e.id;
