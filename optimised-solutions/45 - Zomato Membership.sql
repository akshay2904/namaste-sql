-- ======================================================================
-- 45 - Zomato Membership
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Zomato
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/45-zomato-membership
-- ======================================================================

/*
Zomato is planning to offer a premium membership to customers who have placed multiple orders in a single day.

Your task is to write a SQL to find those customers who have placed multiple orders in a single day at least once , total order value generate by those customers and order value generated only by those orders, display the results in ascending order of total order value.

 
Table: orders (primary key : order_id)
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| customer_name | varchar(20) |
| order_date    | datetime    |
| order_id      | int         |
| order_value   | int         |
+---------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_order_counts AS (
    -- Count orders per customer per day using window function
    SELECT
        order_id,
        customer_name,
        order_date::date AS order_day,
        order_value,
        COUNT(order_id) OVER (PARTITION BY customer_name, order_date::date) AS orders_in_day
    FROM orders
),
multi_order_customers AS (
    -- Identify customers who placed multiple orders on at least one day
    SELECT DISTINCT customer_name
    FROM daily_order_counts
    WHERE orders_in_day > 1
),
customer_totals AS (
    SELECT
        d.customer_name,
        SUM(d.order_value) AS total_order_value,
        -- Sum only the orders placed on days with multiple orders
        SUM(CASE WHEN d.orders_in_day > 1 THEN d.order_value ELSE 0 END) AS multi_day_order_value
    FROM daily_order_counts d
    INNER JOIN multi_order_customers m ON d.customer_name = m.customer_name
    GROUP BY d.customer_name
)
SELECT
    customer_name,
    total_order_value,
    multi_day_order_value
FROM customer_totals
ORDER BY total_order_value ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    o.customer_name,
    SUM(o.order_value) AS total_order_value,
    -- Sum order values only from days where multiple orders were placed
    SUM(CASE
            WHEN (o.customer_name, o.order_date::date) IN (
                SELECT customer_name, order_date::date
                FROM orders
                GROUP BY customer_name, order_date::date
                HAVING COUNT(order_id) > 1
            )
            THEN o.order_value
            ELSE 0
        END) AS multi_day_order_value
FROM orders o
WHERE o.customer_name IN (
    -- Find customers who placed more than one order on at least one day
    SELECT customer_name
    FROM orders
    GROUP BY customer_name, order_date::date
    HAVING COUNT(order_id) > 1
)
GROUP BY o.customer_name
ORDER BY total_order_value ASC;
