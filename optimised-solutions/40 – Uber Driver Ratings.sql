-- ======================================================================
-- 40 – Uber Driver Ratings
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Uber
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/40-uber-driver-ratings
-- ======================================================================

/*
Suppose you are a data analyst working for ride-sharing platform Uber. Uber is interested in analyzing the performance of drivers based on their ratings and wants to categorize them into different performance tiers. 

Write an SQL query to categorize drivers equally into three performance tiers (Top, Middle, and Bottom) based on their average ratings. Drivers with the highest average ratings should be placed in the top tier, drivers with ratings below the top tier but above the bottom tier should be placed in the middle tier, and drivers with the lowest average ratings should be placed in the bottom tier. Sort the output in decreasing order of average rating.

 
Table : driver_ratings
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| driver_id   | int          |
| avg_rating  | decimal(3,2) |
+-------------+--------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_drivers AS (
    SELECT
        driver_id,
        avg_rating,
        NTILE(3) OVER (ORDER BY avg_rating DESC) AS tier_rank
    FROM driver_ratings
)
SELECT
    driver_id,
    avg_rating,
    CASE tier_rank
        WHEN 1 THEN 'Top'
        WHEN 2 THEN 'Middle'
        WHEN 3 THEN 'Bottom'
    END AS performance_tier
FROM ranked_drivers
ORDER BY avg_rating DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH driver_count AS (
    -- Get total number of drivers to determine tier boundaries
    SELECT COUNT(*) AS total FROM driver_ratings
),
tier_bounds AS (
    -- Calculate the cutoff points for each tier (top 33%, middle 33%, bottom 33%)
    SELECT
        CEIL(total / 3.0) AS top_cutoff,
        CEIL(total * 2.0 / 3) AS middle_cutoff
    FROM driver_count
),
ranked_drivers AS (
    -- Assign a row number based on avg_rating descending
    SELECT
        driver_id,
        avg_rating,
        ROW_NUMBER() OVER (ORDER BY avg_rating DESC) AS row_num
    FROM driver_ratings
)
SELECT
    rd.driver_id,
    rd.avg_rating,
    CASE
        WHEN rd.row_num <= tb.top_cutoff THEN 'Top'
        WHEN rd.row_num <= tb.middle_cutoff THEN 'Middle'
        ELSE 'Bottom'
    END AS performance_tier
FROM ranked_drivers rd
CROSS JOIN tier_bounds tb
ORDER BY rd.avg_rating DESC;
