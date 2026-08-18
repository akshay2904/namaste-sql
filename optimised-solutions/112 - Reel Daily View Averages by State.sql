-- ======================================================================
-- 112 - Reel Daily View Averages by State
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Meta
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/112-reel-daily-view-averages-by-state
-- ======================================================================

/*
Meta (formerly Facebook) is analyzing the performance of Instagram Reels across different states in the USA. You have access to a table named REEL that tracks the cumulative views of each reel over time. Write an SQL to get average daily views for each Instagram Reel in each state. Round the average to 2 decimal places and sort the result by average is descending order. 

 
Table: reel 
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| reel_id         | int      |    
| record_date     | date     |
| state           | varchar  |
| cumulative_views| int      |
+-------------+--------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_views AS (
    SELECT
        reel_id,
        state,
        record_date,
        -- Daily views = current cumulative - previous day's cumulative
        cumulative_views - LAG(cumulative_views, 1, 0) 
            OVER (PARTITION BY reel_id, state ORDER BY record_date) AS daily_view_count
    FROM reel
)
SELECT
    reel_id,
    state,
    ROUND(AVG(daily_view_count)::NUMERIC, 2) AS avg_daily_views
FROM daily_views
GROUP BY reel_id, state
ORDER BY avg_daily_views DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    r1.reel_id,
    r1.state,
    ROUND(
        AVG(
            r1.cumulative_views - COALESCE(
                (
                    -- For each row, find the previous day's cumulative views
                    SELECT r2.cumulative_views
                    FROM reel r2
                    WHERE r2.reel_id = r1.reel_id
                      AND r2.state  = r1.state
                      AND r2.record_date = (
                          SELECT MAX(r3.record_date)
                          FROM reel r3
                          WHERE r3.reel_id    = r1.reel_id
                            AND r3.state      = r1.state
                            AND r3.record_date < r1.record_date
                      )
                ),
                0  -- No previous record means all views on that day are new
            )
        )::NUMERIC,
        2
    ) AS avg_daily_views
FROM reel r1
GROUP BY r1.reel_id, r1.state
ORDER BY avg_daily_views DESC;
