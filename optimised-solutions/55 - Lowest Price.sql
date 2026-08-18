-- ======================================================================
-- 55 - Lowest Price
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Pwc
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/55-lowest-price
-- ======================================================================

/*
You own a small online store, and want to analyze customer ratings for the products that you're selling. After doing a data pull, you have a list of products and a log of purchases. Within the purchase log, each record includes the number of stars (from 1 to 5) as a customer rating for the product.

For each category, find the lowest price among all products that received at least one 4-star or above rating from customers.
If a product category did not have any products that received at least one 4-star or above rating, the lowest price is considered to be 0. The final output should be sorted by product category in alphabetical order.
Table: products
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| category    | varchar(10) |
| id          | int         |
| name        | varchar(20) |
| price       | int         |
+-------------+-------------+Table: purchases
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| id          | int       |
| product_id  | int       |
| stars       | int       |
+-------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH qualified_products AS (
    -- Products that received at least one rating of 4 or above
    SELECT DISTINCT product_id
    FROM purchases
    WHERE stars >= 4
),
category_min AS (
    SELECT 
        p.category,
        MIN(p.price) AS lowest_price
    FROM products p
    INNER JOIN qualified_products qp ON p.id = qp.product_id
    GROUP BY p.category
)
SELECT 
    pr.category,
    COALESCE(cm.lowest_price, 0) AS lowest_price
FROM (SELECT DISTINCT category FROM products) pr
LEFT JOIN category_min cm ON pr.category = cm.category
ORDER BY pr.category;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    pr.category,
    COALESCE(MIN(pr.price), 0) AS lowest_price
FROM (SELECT DISTINCT category FROM products) cats
LEFT JOIN products pr 
    ON cats.category = pr.category
    AND pr.id IN (
        -- Products with at least one 4-star or above rating
        SELECT product_id
        FROM purchases
        WHERE stars >= 4
        GROUP BY product_id
        HAVING MAX(stars) >= 4
    )
GROUP BY cats.category
ORDER BY cats.category;
