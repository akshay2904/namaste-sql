-- ======================================================================
-- 18 - Hero Products
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Flipkart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/18-hero-products
-- ======================================================================

/*
Flipkart an ecommerce company wants to find out its top most selling product by quantity in each category. In case of a tie when quantities sold are same for more than 1 product, then we need to give preference to the product with higher sales value.

Display category and product in output with category in ascending order.

 
Table: orders
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| category    | varchar(50) |
| order_id    | int         |
| product_id  | varchar(20) |
| quantity    | int         |
| unit_price  | int         |
+-------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH product_sales AS (
    SELECT
        category,
        product_id,
        SUM(quantity) AS total_qty,
        SUM(quantity * unit_price) AS total_sales
    FROM orders
    GROUP BY category, product_id
),
ranked AS (
    SELECT
        category,
        product_id,
        RANK() OVER (
            PARTITION BY category
            ORDER BY total_qty DESC, total_sales DESC
        ) AS rnk
    FROM product_sales
)
SELECT category, product_id AS product
FROM ranked
WHERE rnk = 1
ORDER BY category ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT o.category, o.product_id AS product
FROM (
    SELECT category, product_id,
           SUM(quantity) AS total_qty,
           SUM(quantity * unit_price) AS total_sales
    FROM orders
    GROUP BY category, product_id
) o
WHERE (o.total_qty, o.total_sales) = (
    -- For each category, find the max qty then max sales among those with max qty
    SELECT MAX(inner_sales.total_qty), MAX(inner_sales.total_sales)
    FROM (
        SELECT product_id,
               SUM(quantity) AS total_qty,
               SUM(quantity * unit_price) AS total_sales
        FROM orders
        WHERE category = o.category
        GROUP BY product_id
    ) inner_sales
    WHERE inner_sales.total_qty = (
        SELECT MAX(SUM(quantity))
        FROM orders
        WHERE category = o.category
        GROUP BY product_id
    )
)
ORDER BY o.category ASC;
