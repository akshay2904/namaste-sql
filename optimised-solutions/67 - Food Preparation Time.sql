-- ======================================================================
-- 67 - Food Preparation Time
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Zomato
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/67-food-preparation-time
-- ======================================================================

/*
You're analyzing the efficiency of food delivery on Zomato, focusing on the time taken by restaurants to prepare orders. Total food delivery time for an order is a combination of food preparation time + time taken by rider to deliver the order. 
Write an SQL to calculate average food preparation time(in minutes) for each restaurant . Round the average to 2 decimal points and sort the output in increasing order of average time.

 
Table: orders
+------------------------+-----------+
| COLUMN_NAME            | DATA_TYPE |
+------------------------+-----------+
| order_id               | int       |
| restaurant_id          | int       |
| order_time             | time      |
| expected_delivery_time | time      |
| actual_delivery_time   | time      |
| rider_delivery_mins    | int       |
+------------------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH prep_times AS (
    SELECT
        restaurant_id,
        -- Total delivery window minus rider delivery time = food prep time
        EXTRACT(EPOCH FROM (actual_delivery_time - order_time)) / 60.0
            - rider_delivery_mins AS prep_time_mins
    FROM orders
)
SELECT
    restaurant_id,
    ROUND(AVG(prep_time_mins)::NUMERIC, 2) AS avg_prep_time_mins
FROM prep_times
GROUP BY restaurant_id
ORDER BY avg_prep_time_mins ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    restaurant_id,
    ROUND(
        AVG(
            -- Convert time difference from seconds to minutes, then subtract rider time
            EXTRACT(EPOCH FROM (actual_delivery_time - order_time)) / 60.0
            - rider_delivery_mins
        )::NUMERIC,
        2
    ) AS avg_prep_time_mins
FROM orders
GROUP BY restaurant_id
ORDER BY avg_prep_time_mins ASC;
