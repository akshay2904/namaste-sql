-- ======================================================================
-- 75 - Rider Ride Time
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Swiggy
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/75-rider-ride-time
-- ======================================================================

/*
You are working with Zomato, a food delivery platform, and you need to analyze the performance of Zomato riders in terms of the time they spend delivering orders each day. Given the pickup and delivery times for each order, your task is to calculate the duration of time spent by each rider on deliveries each day.  Order the output by rider id and ride date.

 
Table:orders 
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| rider_id      | int       |
| order_id      | int       |
| pickup_time   | datetime  |
| delivery_time | datetime  |
+---------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH delivery_durations AS (
    SELECT
        rider_id,
        DATE(pickup_time) AS ride_date,
        -- Calculate duration in minutes for each order
        SUM(EXTRACT(EPOCH FROM (delivery_time - pickup_time)) / 60) AS total_minutes
    FROM orders
    GROUP BY rider_id, DATE(pickup_time)
)
SELECT
    rider_id,
    ride_date,
    ROUND(total_minutes::NUMERIC, 2) AS total_delivery_duration_minutes,
    -- Format as HH:MM:SS for readability
    MAKE_INTERVAL(secs => total_minutes * 60) AS total_delivery_duration
FROM delivery_durations
ORDER BY rider_id, ride_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    rider_id,
    DATE(pickup_time) AS ride_date,
    -- Sum total minutes spent delivering per rider per day
    ROUND(
        SUM(
            EXTRACT(EPOCH FROM (delivery_time - pickup_time)) / 60
        )::NUMERIC, 2
    ) AS total_delivery_duration_minutes,
    -- Also show formatted duration
    MAKE_INTERVAL(
        secs => SUM(EXTRACT(EPOCH FROM (delivery_time - pickup_time)))
    ) AS total_delivery_duration
FROM orders
GROUP BY rider_id, DATE(pickup_time)
ORDER BY rider_id, ride_date;
