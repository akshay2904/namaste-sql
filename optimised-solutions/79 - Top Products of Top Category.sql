-- ======================================================================
-- 79 - Top Products of Top Category
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/79-top-products-of-top-category
-- ======================================================================

/*
You are analyzing sales data from an e-commerce platform, which includes information about orders placed for various products across different categories. Each order contains details such as the order ID, order date, product ID, category, and amount.
Write an SQL to identify the top 3 products within the top-selling category based on total sales. The top-selling category is determined by the sum of the amounts sold for all products within that category. Sort the output by products sales in descending order.

 
Table: orders
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| amount      | int         |
| category    | varchar(20) |
| order_date  | date        |
| order_id    | int         |
| product_id  | int         |
+-------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH category_product_sales AS (
    SELECT
        category,
        product_id,
        SUM(amount) AS product_sales,
        SUM(SUM(amount)) OVER (PARTITION BY category) AS category_sales,
        RANK() OVER (ORDER BY SUM(SUM(amount)) OVER (PARTITION BY category) DESC) AS category_rank,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(amount) DESC) AS product_rank
    FROM orders
    GROUP BY category, product_id
)
SELECT
    category,
    product_id,
    product_sales
FROM category_product_sales
WHERE category_rank = 1
  AND product_rank <= 3
ORDER BY product_sales DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Step 1: Find the top-selling category
-- Step 2: Get product sales within that category
-- Step 3: Return top 3 products

SELECT
    p.category,
    p.product_id,
    p.product_sales
FROM (
    -- Product-level sales filtered to the top category
    SELECT
        category,
        product_id,
        SUM(amount) AS product_sales
    FROM orders
    WHERE category = (
        -- Top-selling category by total amount
        SELECT category
        FROM orders
        GROUP BY category
        ORDER BY SUM(amount) DESC
        LIMIT 1
    )
    GROUP BY category, product_id
    ORDER BY product_sales DESC
    LIMIT 3
) p
ORDER BY p.product_sales DESC;
