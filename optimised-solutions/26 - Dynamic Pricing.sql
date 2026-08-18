-- ======================================================================
-- 26 - Dynamic Pricing
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Walmart
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/26-dynamic-pricing
-- ======================================================================

/*
You are given a products table where a new row is inserted every time the price of a product changes. Additionally, there is a transaction table containing details such as order_date and product_id for each order.

Write an SQL query to calculate the total sales value for each product, considering the cost of the product at the time of the order date, display the output in ascending order of the product_id.

 
Table: products
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| product_id  | int       |
| price       | int       |
| price_date  | date      |
+-------------+-----------+Table: orders 
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_id    | int       |
| order_date  | date      |
| product_id  | int       |
+-------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH price_ranges AS (
    SELECT
        product_id,
        price,
        price_date AS valid_from,
        -- Next price change date (or far future if still current price)
        LEAD(price_date) OVER (PARTITION BY product_id ORDER BY price_date) AS valid_to
    FROM products
)
SELECT
    o.product_id,
    SUM(pr.price) AS total_sales_value
FROM orders o
JOIN price_ranges pr
    ON o.product_id = pr.product_id
    -- Order date falls within this price's validity window
    AND o.order_date >= pr.valid_from
    AND (o.order_date < pr.valid_to OR pr.valid_to IS NULL)
GROUP BY o.product_id
ORDER BY o.product_id ASC;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    o.product_id,
    SUM(
        -- For each order, find the price that was active on the order date:
        -- the most recent price_date that is <= order_date
        (SELECT p.price
         FROM products p
         WHERE p.product_id = o.product_id
           AND p.price_date <= o.order_date
         ORDER BY p.price_date DESC
         LIMIT 1)
    ) AS total_sales_value
FROM orders o
GROUP BY o.product_id
ORDER BY o.product_id ASC;
