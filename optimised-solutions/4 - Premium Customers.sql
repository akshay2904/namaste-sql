-- ======================================================================
-- 4 - Premium Customers
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/4-premium-customers
-- ======================================================================

/*
An e-commerce company want to start special reward program for their premium customers.  The customers who have placed a greater number of orders than the average number of orders placed by customers are considered as premium customers.

 

Write an SQL to find the list of premium customers along with the number of orders placed by each of them, display the results in highest to lowest no of orders.

 
Table: orders (primary key : order_id)
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| order_id      | int         |
| order_date    | date        |
| customer_name | varchar(20) |
| sales         | int         |
+---------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH customer_order_counts AS (
    SELECT
        customer_name,
        COUNT(order_id) AS num_orders,
        -- Compute overall average order count per customer using window function (single scan)
        AVG(COUNT(order_id)) OVER () AS avg_orders
    FROM orders
    GROUP BY customer_name
)
SELECT
    customer_name,
    num_orders
FROM customer_order_counts
WHERE num_orders > avg_orders
ORDER BY num_orders DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    customer_name,
    COUNT(order_id) AS num_orders
FROM orders
GROUP BY customer_name
HAVING COUNT(order_id) > (
    -- Subquery: compute average number of orders across all customers
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(order_id) AS order_count
        FROM orders
        GROUP BY customer_name
    ) AS customer_counts
)
ORDER BY num_orders DESC;
