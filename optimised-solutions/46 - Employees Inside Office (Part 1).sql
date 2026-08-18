-- ======================================================================
-- 46 - Employees Inside Office (Part 1)
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Gameberry labs
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/46-employees-inside-office-part-1
-- ======================================================================

/*
A company record its employee's movement In and Out of office in a table. Please note below points about the data:

 
1- First entry for each employee is “in”
2- Every “in” is succeeded by an “out”
3- Employee can work across days
Write a SQL to find the number of employees inside the Office at “2019-04-01 19:05:00".

 
Table: employee_record
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| emp_id      | int        |
| action      | varchar(3) |
| created_at  | datetime   |
+-------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        emp_id,
        action,
        created_at,
        -- Get the next action's timestamp for each record
        LEAD(created_at) OVER (PARTITION BY emp_id ORDER BY created_at) AS next_at
    FROM employee_record
)
SELECT COUNT(DISTINCT emp_id) AS employees_in_office
FROM ranked
WHERE action = 'in'
  AND created_at  <= '2019-04-01 19:05:00'   -- they entered before or at the snapshot
  AND (next_at IS NULL OR next_at > '2019-04-01 19:05:00'); -- they haven't left yet

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- For each employee, find their most recent action on or before the target time.
-- If that action is 'in', they are currently inside the office.
SELECT COUNT(*) AS employees_in_office
FROM (
    SELECT er.emp_id
    FROM employee_record er
    -- Join to find the latest record per employee up to the target timestamp
    INNER JOIN (
        SELECT emp_id, MAX(created_at) AS last_action_time
        FROM employee_record
        WHERE created_at <= '2019-04-01 19:05:00'
        GROUP BY emp_id
    ) latest
        ON er.emp_id      = latest.emp_id
        AND er.created_at = latest.last_action_time
    WHERE er.action = 'in'
) inside_employees;
