-- ======================================================================
-- 59 - Order Lead Time
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/59-order-lead-time
-- ======================================================================

/*
You are given orders data of an online ecommerce company. Dataset contains order_id , order_date and ship_date. Your task is to find lead time in days between order date and ship date using below rules:

 
1- Exclude holidays. List of holidays present in holiday table. 
2- If the order date is on weekends, then consider it as order placed on immediate next Monday 
and if the ship date is on weekends, then consider it as immediate previous Friday to do calculations.
For example, if order date is March 14th 2024 and ship date is March 20th 2024. Consider March 18th is a holiday then lead time will be (20-14) -1 holiday = 5 days.

Table: orders
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_date  | date      |
| order_id    | int       |
| ship_date   | date      |
+-------------+-----------+Table: holidays
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| holiday_date | date      |
| holiday_id   | int       |
+--------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH adjusted_orders AS (
    SELECT
        order_id,
        -- If order_date falls on Saturday (6) or Sunday (0), move to next Monday
        CASE
            WHEN EXTRACT(DOW FROM order_date) = 6 THEN order_date + INTERVAL '2 days'
            WHEN EXTRACT(DOW FROM order_date) = 0 THEN order_date + INTERVAL '1 day'
            ELSE order_date
        END AS adj_order_date,
        -- If ship_date falls on Saturday (6) or Sunday (0), move to previous Friday
        CASE
            WHEN EXTRACT(DOW FROM ship_date) = 6 THEN ship_date - INTERVAL '1 day'
            WHEN EXTRACT(DOW FROM ship_date) = 0 THEN ship_date - INTERVAL '2 days'
            ELSE ship_date
        END AS adj_ship_date
    FROM orders
),
holiday_counts AS (
    -- Count holidays that fall strictly between adj_order_date and adj_ship_date
    -- and are not on weekends (weekend holidays wouldn't count as business days anyway)
    SELECT
        o.order_id,
        COUNT(h.holiday_date) AS holidays_in_range
    FROM adjusted_orders o
    LEFT JOIN holidays h
        ON h.holiday_date > o.adj_order_date
        AND h.holiday_date < o.adj_ship_date
        AND EXTRACT(DOW FROM h.holiday_date) NOT IN (0, 6)  -- exclude weekend holidays
    GROUP BY o.order_id
)
SELECT
    o.order_id,
    o.adj_order_date,
    o.adj_ship_date,
    -- Lead time = difference in days minus holidays falling in between
    (o.adj_ship_date - o.adj_order_date) - hc.holidays_in_range AS lead_time_days
FROM adjusted_orders o
JOIN holiday_counts hc ON o.order_id = hc.order_id
ORDER BY o.order_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ord.order_id,
    adj_order_date,
    adj_ship_date,
    (adj_ship_date - adj_order_date) - COALESCE(holiday_count, 0) AS lead_time_days
FROM (
    -- Step 1: Adjust order_date and ship_date for weekends
    SELECT
        order_id,
        CASE
            WHEN EXTRACT(DOW FROM order_date) = 6 THEN order_date + 2  -- Sat -> Mon
            WHEN EXTRACT(DOW FROM order_date) = 0 THEN order_date + 1  -- Sun -> Mon
            ELSE order_date
        END AS adj_order_date,
        CASE
            WHEN EXTRACT(DOW FROM ship_date) = 6 THEN ship_date - 1    -- Sat -> Fri
            WHEN EXTRACT(DOW FROM ship_date) = 0 THEN ship_date - 2    -- Sun -> Fri
            ELSE ship_date
        END AS adj_ship_date
    FROM orders
) ord
LEFT JOIN (
    -- Step 2: For each order, count holidays strictly between adjusted dates
    --         that are not on weekends
    SELECT
        sub.order_id,
        COUNT(h.holiday_date) AS holiday_count
    FROM (
        SELECT
            order_id,
            CASE
                WHEN EXTRACT(DOW FROM order_date) = 6 THEN order_date + 2
                WHEN EXTRACT(DOW FROM order_date) = 0 THEN order_date + 1
                ELSE order_date
            END AS adj_order_date,
            CASE
                WHEN EXTRACT(DOW FROM ship_date) = 6 THEN ship_date - 1
                WHEN EXTRACT(DOW FROM ship_date) = 0 THEN ship_date - 2
                ELSE ship_date
            END AS adj_ship_date
        FROM orders
    ) sub
    JOIN holidays h
        ON h.holiday_date > sub.adj_order_date
        AND h.holiday_date < sub.adj_ship_date
        AND EXTRACT(DOW FROM h.holiday_date) NOT IN (0, 6)
    GROUP BY sub.order_id
) hc ON ord.order_id = hc.order_id
ORDER BY ord.order_id;
