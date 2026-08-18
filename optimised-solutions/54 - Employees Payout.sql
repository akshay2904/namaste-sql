-- ======================================================================
-- 54 - Employees Payout
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Deloitte
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/54-employees-payout
-- ======================================================================

/*
An IT company pays its employees on hourly basis. You are given the database of employees along with their department id.

 
Table: employees
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| emp_id      | int         |
| emp_name    | varchar(20) |
| dept_id     | int         |
+-------------+-------------+
Department table which consist of hourly rate for each department.

 
Table: dept
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| dept_id     | int       |
| hourly_rate | int       |
+-------------+-----------+

Given the daily entry_time and exit_time of each employee, calculate the total amount payable to each employee.

 
Table: daily_time
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| emp_id      | int       |
| entry_time  | datetime  |
| exit_time   | datetime  |
+-------------+-----------+
Please note that company also pays overtime to employees who work for more than 8 hours a day which is 1.5 times of hourly rate. So for example if hourly rate is 10 and a employee works for 9 hours then total payable will be 10*8+15*1 = 95 for that day. In this example 95 is total payout and 15 is overtime payout.  Round the result to 2 decimal places and sort the output by decreasing order of total payout.
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_hours AS (
    -- Calculate hours worked each day per employee
    SELECT
        emp_id,
        EXTRACT(EPOCH FROM (exit_time - entry_time)) / 3600.0 AS hours_worked
    FROM daily_time
),
daily_pay AS (
    -- Calculate pay per day considering overtime (>8 hours at 1.5x rate)
    SELECT
        dh.emp_id,
        d.hourly_rate,
        dh.hours_worked,
        CASE
            WHEN dh.hours_worked <= 8
                THEN dh.hours_worked * d.hourly_rate
            ELSE
                (8 * d.hourly_rate) + ((dh.hours_worked - 8) * d.hourly_rate * 1.5)
        END AS day_pay
    FROM daily_hours dh
    JOIN employees e ON dh.emp_id = e.emp_id
    JOIN dept d      ON e.dept_id  = d.dept_id
)
SELECT
    e.emp_id,
    e.emp_name,
    ROUND(SUM(dp.day_pay)::NUMERIC, 2) AS total_payout
FROM daily_pay dp
JOIN employees e ON dp.emp_id = e.emp_id
GROUP BY e.emp_id, e.emp_name
ORDER BY total_payout DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    e.emp_id,
    e.emp_name,
    ROUND(
        SUM(
            CASE
                -- Regular hours only (<=8 hrs)
                WHEN (EXTRACT(EPOCH FROM (dt.exit_time - dt.entry_time)) / 3600.0) <= 8
                    THEN (EXTRACT(EPOCH FROM (dt.exit_time - dt.entry_time)) / 3600.0) * d.hourly_rate
                -- Regular 8 hours + overtime beyond 8 hours at 1.5x
                ELSE
                    (8 * d.hourly_rate)
                    + ((EXTRACT(EPOCH FROM (dt.exit_time - dt.entry_time)) / 3600.0 - 8)
                       * d.hourly_rate * 1.5)
            END
        )::NUMERIC,
    2) AS total_payout
FROM daily_time dt
JOIN employees  e ON dt.emp_id  = e.emp_id
JOIN dept       d ON e.dept_id  = d.dept_id
GROUP BY e.emp_id, e.emp_name
ORDER BY total_payout DESC;
