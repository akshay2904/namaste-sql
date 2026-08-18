-- ======================================================================
-- 23 - Product Recommendation
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/23-product-recommendation
-- ======================================================================

/*
Product recommendation. Just the basic type (“customers who bought this also bought…”). That, in its simplest form, is an outcome of basket analysis. Write a SQL to find the product pairs which have been purchased together in same order along with the purchase frequency (count of times they have been purchased together). Based on this data Amazon can recommend frequently bought together products to other users.

Order the output by purchase frequency in descending order. Please make in the output first product column has id greater than second product column. 

 
Table: orders (primary key : order_id)
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| order_id    | int        |
| customer_id | int        |
| product_id  | varchar(2) |
+-------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH order_pairs AS (
    SELECT
        o1.order_id,
        -- Ensure first product column has greater id than second
        GREATEST(o1.product_id::int, o2.product_id::int) AS product1_id,
        LEAST(o1.product_id::int, o2.product_id::int)    AS product2_id
    FROM orders o1
    JOIN orders o2
        ON o1.order_id = o2.order_id
        AND o1.product_id > o2.product_id  -- avoid duplicates and self-pairs
)
SELECT
    product1_id,
    product2_id,
    COUNT(*) AS purchase_frequency
FROM order_pairs
GROUP BY product1_id, product2_id
ORDER BY purchase_frequency DESC,
         product1_id DESC,
         product2_id DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    -- Product with greater id goes to first column
    CASE
        WHEN o1.product_id::int > o2.product_id::int THEN o1.product_id::int
        ELSE o2.product_id::int
    END AS product1_id,
    CASE
        WHEN o1.product_id::int > o2.product_id::int THEN o2.product_id::int
        ELSE o1.product_id::int
    END AS product2_id,
    COUNT(*) AS purchase_frequency
FROM orders o1
JOIN orders o2
    ON o1.order_id = o2.order_id          -- same order
    AND o1.product_id <> o2.product_id    -- exclude same product pairing
WHERE o1.product_id::int > o2.product_id::int  -- avoid counting pairs twice
GROUP BY
    CASE
        WHEN o1.product_id::int > o2.product_id::int THEN o1.product_id::int
        ELSE o2.product_id::int
    END,
    CASE
        WHEN o1.product_id::int > o2.product_id::int THEN o2.product_id::int
        ELSE o1.product_id::int
    END
ORDER BY purchase_frequency DESC,
         product1_id DESC,
         product2_id DESC;
