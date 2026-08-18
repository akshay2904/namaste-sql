-- ======================================================================
-- 68 - Late Food Deliveries
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Zomato
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/68-late-food-deliveries
-- ======================================================================

/*
You’re analyzing late deliveries on Zomato. Each order’s total delivery time is split equally:

50% for food preparation (restaurant)

50% for the rider's trip

Goal: Find orders that were late ONLY because the rider took longer than expected. In other words, food was ready on time, but the rider was slow.

Display the following for each such order:

order_id

expected_delivery_mins

rider_delivery_mins

food_prep_mins

Sort the results by order_id in ascending order.

 
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

WITH delivery_breakdown AS (
    SELECT
        order_id,
        -- Total expected delivery window in minutes
        EXTRACT(EPOCH FROM (expected_delivery_time - order_time)) / 60 AS expected_delivery_mins,
        -- Actual rider delivery time (given directly)
        rider_delivery_mins,
        -- Total actual delivery time in minutes
        EXTRACT(EPOCH FROM (actual_delivery_time - order_time)) / 60 AS actual_total_mins,
        -- Food prep = 50% of expected total delivery time
        EXTRACT(EPOCH FROM (expected_delivery_time - order_time)) / 60 / 2.0 AS expected_food_prep_mins,
        -- Actual food prep = actual total - rider delivery
        (EXTRACT(EPOCH FROM (actual_delivery_time - order_time)) / 60) - rider_delivery_mins AS food_prep_mins
    FROM orders
)
SELECT
    order_id,
    expected_delivery_mins::int,
    rider_delivery_mins,
    food_prep_mins::int
FROM delivery_breakdown
WHERE
    -- Order was late overall
    actual_total_mins > expected_delivery_mins
    -- Food was ready on time (actual food prep <= expected food prep = 50% of expected total)
    AND food_prep_mins <= expected_food_prep_mins
    -- Rider was slow (rider time exceeded the expected 50% allotted for the trip)
    AND rider_delivery_mins > expected_food_prep_mins
ORDER BY order_id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    order_id,
    -- Total expected delivery in minutes
    CAST(EXTRACT(EPOCH FROM (expected_delivery_time - order_time)) / 60 AS int) AS expected_delivery_mins,
    rider_delivery_mins,
    -- Actual food prep = actual total time minus rider time
    CAST(
        (EXTRACT(EPOCH FROM (actual_delivery_time - order_time)) / 60) - rider_delivery_mins
    AS int) AS food_prep_mins
FROM orders
WHERE
    -- Order was late: actual delivery exceeded expected delivery
    EXTRACT(EPOCH FROM (actual_delivery_time - order_time)) / 60
        > EXTRACT(EPOCH FROM (expected_delivery_time - order_time)) / 60

    -- Food was on time: actual food prep <= 50% of expected total
    AND (
        (EXTRACT(EPOCH FROM (actual_delivery_time - order_time)) / 60) - rider_delivery_mins
    ) <= (
        EXTRACT(EPOCH FROM (expected_delivery_time - order_time)) / 60 / 2.0
    )

    -- Rider was slow: rider time exceeded the 50% expected rider window
    AND rider_delivery_mins > (
        EXTRACT(EPOCH FROM (expected_delivery_time - order_time)) / 60 / 2.0
    )
ORDER BY order_id ASC;
