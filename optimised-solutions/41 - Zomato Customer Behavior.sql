-- ======================================================================
-- 41 - Zomato Customer Behavior
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Zomato
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/41-zomato-customer-behavior
-- ======================================================================

/*
Suppose you are a data analyst working for Zomato (a online food delivery company) . Zomato is interested in analysing customer food ordering behavior and wants to identify customers who have exhibited inconsistent patterns over time.

Your task is to write an SQL query to identify customers who have placed orders on both weekdays and weekends, but with a significant difference in the average order amount between weekdays and weekends. Specifically, you need to identify customers who have a minimum of 3 orders placed both on weekdays and weekends each, and where the average order amount on weekends is at least 20% higher than the average order amount on weekdays.

Your query should return the customer id, the average order amount on weekends, the average order amount on weekdays, and the percentage difference (round to 2 decimal places) in average order amount between weekends and weekdays for each customer meeting the criteria.

 
Table: orders
+--------------+---------------+
| COLUMN_NAME  | DATA_TYPE     |
+--------------+---------------+
| order_id     | int           |
| customer_id  | int           |
| order_amount | decimal(10,2) |
| order_date   | date          |
+--------------+---------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH order_stats AS (
    SELECT
        customer_id,
        -- Classify each order as weekend or weekday in one pass
        CASE
            WHEN EXTRACT(DOW FROM order_date) IN (0, 6) THEN 'weekend'
            ELSE 'weekday'
        END AS day_type,
        order_amount
    FROM orders
),
aggregated AS (
    SELECT
        customer_id,
        -- Weekend metrics
        AVG(order_amount) FILTER (WHERE day_type = 'weekend')       AS avg_weekend,
        COUNT(*)          FILTER (WHERE day_type = 'weekend')       AS cnt_weekend,
        -- Weekday metrics
        AVG(order_amount) FILTER (WHERE day_type = 'weekday')       AS avg_weekday,
        COUNT(*)          FILTER (WHERE day_type = 'weekday')       AS cnt_weekday
    FROM order_stats
    GROUP BY customer_id
)
SELECT
    customer_id,
    ROUND(avg_weekend, 2)                                            AS avg_weekend_order_amount,
    ROUND(avg_weekday, 2)                                           AS avg_weekday_order_amount,
    -- Percentage difference: how much higher weekend avg is vs weekday avg
    ROUND(((avg_weekend - avg_weekday) / avg_weekday) * 100, 2)    AS pct_difference
FROM aggregated
WHERE
    cnt_weekend >= 3
    AND cnt_weekday >= 3
    -- Weekend average is at least 20% higher than weekday average
    AND avg_weekend >= avg_weekday * 1.20
ORDER BY pct_difference DESC;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    w.customer_id,
    ROUND(w.avg_weekend_amount, 2)                                              AS avg_weekend_order_amount,
    ROUND(d.avg_weekday_amount, 2)                                              AS avg_weekday_order_amount,
    ROUND(
        ((w.avg_weekend_amount - d.avg_weekday_amount) / d.avg_weekday_amount) * 100,
        2
    )                                                                           AS pct_difference
FROM
    -- Subquery for weekend orders per customer
    (
        SELECT
            customer_id,
            AVG(order_amount) AS avg_weekend_amount,
            COUNT(*)          AS weekend_order_count
        FROM orders
        WHERE EXTRACT(DOW FROM order_date) IN (0, 6)   -- 0 = Sunday, 6 = Saturday
        GROUP BY customer_id
        HAVING COUNT(*) >= 3
    ) w
    INNER JOIN
    -- Subquery for weekday orders per customer
    (
        SELECT
            customer_id,
            AVG(order_amount) AS avg_weekday_amount,
            COUNT(*)          AS weekday_order_count
        FROM orders
        WHERE EXTRACT(DOW FROM order_date) NOT IN (0, 6)
        GROUP BY customer_id
        HAVING COUNT(*) >= 3
    ) d
    ON w.customer_id = d.customer_id
WHERE
    -- Weekend average must be at least 20% higher than weekday average
    w.avg_weekend_amount >= d.avg_weekday_amount * 1.20
ORDER BY pct_difference DESC;
