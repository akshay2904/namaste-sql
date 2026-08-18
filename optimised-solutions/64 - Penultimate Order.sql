-- ======================================================================
-- 64 - Penultimate Order
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Walmart
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/64-penultimate-order
-- ======================================================================

/*
You are a data analyst working for an e-commerce company, responsible for analysing customer orders to gain insights into their purchasing behaviour. Your task is to write a SQL query to retrieve the details of the penultimate order for each customer. However, if a customer has placed only one order, you need to retrieve the details of that order instead, display the output in ascending order of customer name.

 
Table: orders
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| order_id      | int         |
| order_date    | date        |
| customer_name | varchar(10) |
| product_name  | varchar(50) |
| sales         | int         |
+---------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        order_id,
        order_date,
        customer_name,
        product_name,
        sales,
        ROW_NUMBER() OVER (PARTITION BY customer_name ORDER BY order_date DESC) AS rn,
        COUNT(*)     OVER (PARTITION BY customer_name)                          AS total_orders
    FROM orders
)
SELECT
    order_id,
    order_date,
    customer_name,
    product_name,
    sales
FROM ranked
-- rn=2 is the penultimate; if only 1 order exists, total_orders=1 so rn=1 applies
WHERE (total_orders > 1 AND rn = 2)
   OR (total_orders = 1 AND rn = 1)
ORDER BY customer_name ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    o.order_id,
    o.order_date,
    o.customer_name,
    o.product_name,
    o.sales
FROM orders o
WHERE o.order_date = (
    -- For customers with >1 order: find the max date EXCLUDING the latest order date
    SELECT MAX(o2.order_date)
    FROM orders o2
    WHERE o2.customer_name = o.customer_name
      AND o2.order_date < (
            SELECT MAX(o3.order_date)
            FROM orders o3
            WHERE o3.customer_name = o.customer_name
          )
)
UNION ALL
-- Customers with exactly one order
SELECT
    o.order_id,
    o.order_date,
    o.customer_name,
    o.product_name,
    o.sales
FROM orders o
WHERE o.customer_name IN (
    SELECT customer_name
    FROM orders
    GROUP BY customer_name
    HAVING COUNT(*) = 1
)
ORDER BY customer_name ASC;
