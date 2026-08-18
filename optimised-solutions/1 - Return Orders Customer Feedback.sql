-- ======================================================================
-- 1 - Return Orders Customer Feedback
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/1-return-orders-customer-feedback
-- ======================================================================

/*
Namastekart, an e-commerce company, has observed a notable surge in return orders recently. They suspect that a specific group of customers may be responsible for a significant portion of these returns. To address this issue, their initial goal is to identify customers who have returned more than 50% of their orders. This way, they can proactively reach out to these customers to gather feedback.

 

Write an SQL to find list of customers along with their return percent (Round to 2 decimal places), display the output in ascending order of customer name.

Table: orders (primary key : order_id)
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| customer_name | varchar(10) |
| order_date    | date        |
| order_id      | int         |
| sales         | int         |
+---------------+-------------+

Table: returns (primary key : order_id)
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_id    | int       |
| return_date | date      |
+-------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH customer_stats AS (
    SELECT
        o.customer_name,
        COUNT(o.order_id) AS total_orders,
        COUNT(r.order_id) AS returned_orders
    FROM orders o
    LEFT JOIN returns r ON o.order_id = r.order_id
    GROUP BY o.customer_name
)
SELECT
    customer_name,
    ROUND((returned_orders * 100.0 / total_orders), 2) AS return_percent
FROM customer_stats
WHERE (returned_orders * 100.0 / total_orders) > 50
ORDER BY customer_name ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    customer_name,
    ROUND(
        (COUNT(r.order_id) * 100.0 / COUNT(o.order_id)),
        2
    ) AS return_percent
FROM orders o
LEFT JOIN returns r ON o.order_id = r.order_id
GROUP BY customer_name
HAVING (COUNT(r.order_id) * 100.0 / COUNT(o.order_id)) > 50
ORDER BY customer_name ASC;
