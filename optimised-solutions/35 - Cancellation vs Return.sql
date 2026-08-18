-- ======================================================================
-- 35 - Cancellation vs Return
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/35-cancellation-vs-return
-- ======================================================================

/*
You are given an orders table containing data about orders placed on an e-commerce website, with information on order date, delivery date, and cancel date. The task is to calculate both the cancellation rate and the return rate for each month based on the order date.

Definitions:

An order is considered cancelled if it is cancelled before delivery (i.e., cancel_date is not null, and delivery_date is null). If an order is cancelled, no delivery will take place.
An order is considered a return if it is cancelled after it has already been delivered (i.e., cancel_date is not null, and cancel_date > delivery_date).

Metrics to Calculate:
Cancel Rate = (Number of orders cancelled / Number of orders placed but not returned) * 100
Return Rate = (Number of orders returned / Number of orders placed but not cancelled) * 100

Write an SQL query to calculate the cancellation rate and return rate for each month (based on the order_date).Round the rates to 2 decimal places. Sort the output by year and month in increasing order.
 
Table: orders 
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| order_id      | int       |
| order_date    | date      |
| customer_id   | int       |
| delivery_date | date      |
| cancel_date   | date      |
+---------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_stats AS (
    SELECT
        DATE_TRUNC('month', order_date) AS order_month,
        EXTRACT(YEAR FROM order_date)   AS yr,
        EXTRACT(MONTH FROM order_date)  AS mo,
        -- Cancelled: cancel_date is not null AND delivery_date is null
        COUNT(*) FILTER (WHERE cancel_date IS NOT NULL AND delivery_date IS NULL) AS cancelled_count,
        -- Returned: cancel_date is not null AND cancel_date > delivery_date
        COUNT(*) FILTER (WHERE cancel_date IS NOT NULL AND cancel_date > delivery_date) AS returned_count,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date),
             EXTRACT(YEAR FROM order_date),
             EXTRACT(MONTH FROM order_date)
)
SELECT
    yr::INT                          AS year,
    mo::INT                          AS month,
    -- Cancel Rate = cancelled / (total - returned) * 100
    ROUND(
        cancelled_count * 100.0
        / NULLIF(total_orders - returned_count, 0),
        2
    )                                AS cancel_rate,
    -- Return Rate = returned / (total - cancelled) * 100
    ROUND(
        returned_count * 100.0
        / NULLIF(total_orders - cancelled_count, 0),
        2
    )                                AS return_rate
FROM monthly_stats
ORDER BY yr, mo;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    EXTRACT(YEAR FROM order_date)::INT  AS year,
    EXTRACT(MONTH FROM order_date)::INT AS month,
    -- Cancel Rate = cancelled / (total - returned) * 100
    ROUND(
        SUM(
            CASE WHEN cancel_date IS NOT NULL AND delivery_date IS NULL THEN 1 ELSE 0 END
        ) * 100.0
        / NULLIF(
            COUNT(*)
            - SUM(CASE WHEN cancel_date IS NOT NULL AND cancel_date > delivery_date THEN 1 ELSE 0 END),
            0
        ),
        2
    ) AS cancel_rate,
    -- Return Rate = returned / (total - cancelled) * 100
    ROUND(
        SUM(
            CASE WHEN cancel_date IS NOT NULL AND cancel_date > delivery_date THEN 1 ELSE 0 END
        ) * 100.0
        / NULLIF(
            COUNT(*)
            - SUM(CASE WHEN cancel_date IS NOT NULL AND delivery_date IS NULL THEN 1 ELSE 0 END),
            0
        ),
        2
    ) AS return_rate
FROM orders
GROUP BY
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date)
ORDER BY
    EXTRACT(YEAR FROM order_date),
    EXTRACT(MONTH FROM order_date);
