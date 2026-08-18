-- ======================================================================
-- 47 - Employees Inside Office (Part 2)
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Gameberry labs
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/47-employees-inside-office-part-2
-- ======================================================================

/*
A company record its employee's movement In and Out of office in a table. Please note below points about the data:

 
1- First entry for each employee is “in”
2- Every “in” is succeeded by an “out”
3- Employee can work across days
Write an SQL to measure the time spent by each employee inside the office between “2019-04-01 14:00:00” and “2019-04-02 10:00:00" in minutes, display the output in ascending order of employee id .

 
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
        -- Pair each 'in' with its corresponding 'out' using LEAD
        LEAD(created_at) OVER (PARTITION BY emp_id ORDER BY created_at) AS next_time,
        LEAD(action)     OVER (PARTITION BY emp_id ORDER BY created_at) AS next_action
    FROM employee_record
),
pairs AS (
    SELECT
        emp_id,
        created_at  AS time_in,
        next_time   AS time_out
    FROM ranked
    WHERE action = 'in'
      AND next_action = 'out'  -- safety check; guaranteed by problem rules
),
window_start AS TIMESTAMP '2019-04-01 14:00:00',
window_end   AS TIMESTAMP '2019-04-02 10:00:00',
clipped AS (
    SELECT
        emp_id,
        -- Clip the in/out times to the measurement window
        GREATEST(time_in,  TIMESTAMP '2019-04-01 14:00:00') AS clipped_in,
        LEAST  (time_out,  TIMESTAMP '2019-04-02 10:00:00') AS clipped_out
    FROM pairs
    -- Only keep sessions that overlap with the window
    WHERE time_in  < TIMESTAMP '2019-04-02 10:00:00'
      AND time_out > TIMESTAMP '2019-04-01 14:00:00'
)
SELECT
    emp_id,
    SUM(
        EXTRACT(EPOCH FROM (clipped_out - clipped_in)) / 60
    ) AS minutes_spent
FROM clipped
GROUP BY emp_id
ORDER BY emp_id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    i.emp_id,
    SUM(
        EXTRACT(EPOCH FROM (
            -- Clip the end of the session to the window end
            LEAST(o.created_at, TIMESTAMP '2019-04-02 10:00:00')
            -
            -- Clip the start of the session to the window start
            GREATEST(i.created_at, TIMESTAMP '2019-04-01 14:00:00')
        )) / 60
    ) AS minutes_spent
FROM employee_record i
JOIN employee_record o
    ON  i.emp_id   = o.emp_id
    AND i.action   = 'in'
    AND o.action   = 'out'
    -- The 'out' record is the very next record after the 'in' record
    AND o.created_at = (
        SELECT MIN(e2.created_at)
        FROM employee_record e2
        WHERE e2.emp_id     = i.emp_id
          AND e2.action     = 'out'
          AND e2.created_at > i.created_at
    )
-- Only consider sessions overlapping the measurement window
WHERE i.created_at < TIMESTAMP '2019-04-02 10:00:00'
  AND o.created_at > TIMESTAMP '2019-04-01 14:00:00'
GROUP BY i.emp_id
ORDER BY i.emp_id ASC;
