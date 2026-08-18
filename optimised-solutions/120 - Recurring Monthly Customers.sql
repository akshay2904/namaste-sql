-- ======================================================================
-- 120 - Recurring Monthly Customers
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Zepto
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/120-recurring-monthly-customers
-- ======================================================================

/*
In a quick commerce business, Analyzing the frequency and timing of purchases can help the company identify engaged customers and tailor promotions accordingly.

You are tasked to identify customers who have made a minimum of three purchases, ensuring that each purchase occurred in a different month. This information will assist in targeting marketing efforts towards customers who show consistent buying behavior over time.

Write an SQL to display customer id and no of orders placed by them.

 
Table: orders 
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| customer_id   | int       |
| order_id      | int       |
| order_date    | date      |
+---------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_orders AS (
    -- Get distinct year-month combinations per customer to avoid counting same month twice
    SELECT 
        customer_id,
        DATE_TRUNC('month', order_date) AS order_month
    FROM orders
    GROUP BY customer_id, DATE_TRUNC('month', order_date)
),
customer_stats AS (
    SELECT 
        customer_id,
        COUNT(*) AS distinct_months,  -- count of distinct months with purchases
        SUM(COUNT(*)) OVER (PARTITION BY customer_id) AS total_orders  -- reuse scan
    FROM monthly_orders
    GROUP BY customer_id
)
SELECT 
    o.customer_id,
    COUNT(o.order_id) AS no_of_orders
FROM orders o
INNER JOIN customer_stats cs 
    ON o.customer_id = cs.customer_id
   AND cs.distinct_months >= 3  -- at least 3 different months
GROUP BY o.customer_id
ORDER BY o.customer_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    customer_id,
    COUNT(order_id) AS no_of_orders
FROM orders
WHERE customer_id IN (
    -- Subquery: find customers with purchases in at least 3 different months
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(DISTINCT DATE_TRUNC('month', order_date)) >= 3
                        -- each purchase in a different month (year+month combo)
)
GROUP BY customer_id
ORDER BY customer_id;
