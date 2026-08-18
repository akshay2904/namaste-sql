-- ======================================================================
-- 126 - Selective Buyers Analysis
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Flipkart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/126-selective-buyers-analysis
-- ======================================================================

/*
You are given an orders table that contains information about customer purchases, including the products they bought. Write a query to find all customers who have purchased both "Laptop" and "Mouse", but have never purchased "Phone Case". Additionally, include the total number of distinct products purchased by these customers. Sort the result by customer id.

 
Table: orders 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| customer_id | int      |
| order_id    | int      |
| product_name| varchar  |
+-------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH customer_products AS (
    -- Aggregate per customer once
    SELECT
        customer_id,
        COUNT(DISTINCT product_name)                          AS total_distinct_products,
        BOOL_OR(product_name = 'Laptop')                      AS has_laptop,
        BOOL_OR(product_name = 'Mouse')                       AS has_mouse,
        BOOL_OR(product_name = 'Phone Case')                  AS has_phone_case
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_distinct_products
FROM customer_products
WHERE has_laptop
  AND has_mouse
  AND NOT has_phone_case
ORDER BY customer_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT product_name) AS total_distinct_products
FROM orders
WHERE customer_id IN (
    -- Customers who bought Laptop
    SELECT customer_id FROM orders WHERE product_name = 'Laptop'
)
AND customer_id IN (
    -- Customers who bought Mouse
    SELECT customer_id FROM orders WHERE product_name = 'Mouse'
)
AND customer_id NOT IN (
    -- Exclude customers who bought Phone Case
    SELECT customer_id FROM orders WHERE product_name = 'Phone Case'
)
GROUP BY customer_id
ORDER BY customer_id;
