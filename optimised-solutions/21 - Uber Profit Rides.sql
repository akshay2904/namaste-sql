-- ======================================================================
-- 21 - Uber Profit Rides
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Uber
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/21-uber-profit-rides
-- ======================================================================

/*
A profit ride for a Uber driver is considered when the start location and start time of a ride exactly match with the previous ride's end location and end time. 

Write an SQL to calculate total number of rides and total profit rides by each driver, display the output in ascending order of id.

 
Table: drivers
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| id          | varchar(10) |
| start_loc   | varchar(1)  |
| start_time  | time        |
| end_loc     | varchar(1)  |
| end_time    | time        |
+-------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        id,
        start_loc,
        start_time,
        end_loc,
        end_time,
        -- Get previous ride's end_loc and end_time for the same driver
        LAG(end_loc)  OVER (PARTITION BY id ORDER BY start_time) AS prev_end_loc,
        LAG(end_time) OVER (PARTITION BY id ORDER BY start_time) AS prev_end_time
    FROM drivers
)
SELECT
    id,
    COUNT(*)                                                          AS total_rides,
    COUNT(CASE
              WHEN start_loc = prev_end_loc
               AND start_time = prev_end_time THEN 1
          END)                                                        AS total_profit_rides
FROM ranked
GROUP BY id
ORDER BY id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    d1.id,
    COUNT(*)                                                          AS total_rides,
    -- Count rides where start matches a previous ride's end for same driver
    COUNT(CASE
              WHEN EXISTS (
                  SELECT 1
                  FROM drivers d2
                  WHERE d2.id         = d1.id
                    AND d2.end_loc    = d1.start_loc
                    AND d2.end_time   = d1.start_time
                    -- ensure d2 is truly a prior ride
                    AND d2.start_time < d1.start_time
              ) THEN 1
          END)                                                        AS total_profit_rides
FROM drivers d1
GROUP BY d1.id
ORDER BY d1.id ASC;
