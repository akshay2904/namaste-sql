-- ======================================================================
-- 20 - Trending Products
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/20-trending-products
-- ======================================================================

/*
Amazon wants to find out the trending products for each month. Trending products are those for which any given month sales are more than the sum of previous 2 months sales for that product.

Please note that for first 2 months of operations this metrics does not make sense. So output should start from 3rd month only.  Assume that each product has at least 1 sale each month, display order month and product id. Sort by order month.

 
Table: orders 
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| order_month | varchar(6) |
| product_id  | varchar(5) |
| sales       | int        |
+-------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_sales AS (
    SELECT
        order_month,
        product_id,
        SUM(sales) AS total_sales,
        -- Sum of sales 1 month ago
        LAG(SUM(sales), 1) OVER (PARTITION BY product_id ORDER BY order_month) AS prev1_sales,
        -- Sum of sales 2 months ago
        LAG(SUM(sales), 2) OVER (PARTITION BY product_id ORDER BY order_month) AS prev2_sales
    FROM orders
    GROUP BY order_month, product_id
)
SELECT
    order_month,
    product_id
FROM monthly_sales
WHERE
    prev1_sales IS NOT NULL
    AND prev2_sales IS NOT NULL
    AND total_sales > (prev1_sales + prev2_sales)
ORDER BY order_month;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH monthly_sales AS (
    -- Aggregate sales per product per month
    SELECT
        order_month,
        product_id,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY order_month, product_id
),
ranked_months AS (
    -- Assign a row number to each month in chronological order (globally)
    SELECT
        order_month,
        ROW_NUMBER() OVER (ORDER BY order_month) AS month_rank
    FROM orders
    GROUP BY order_month
)
SELECT
    ms.order_month,
    ms.product_id
FROM monthly_sales ms
JOIN ranked_months rm ON ms.order_month = rm.order_month
-- Join to get 1 month ago sales
JOIN monthly_sales ms1 ON ms1.product_id = ms.product_id
JOIN ranked_months rm1 ON ms1.order_month = rm1.order_month AND rm1.month_rank = rm.month_rank - 1
-- Join to get 2 months ago sales
JOIN monthly_sales ms2 ON ms2.product_id = ms.product_id
JOIN ranked_months rm2 ON ms2.order_month = rm2.order_month AND rm2.month_rank = rm.month_rank - 2
WHERE
    -- Only from 3rd month onward
    rm.month_rank >= 3
    AND ms.total_sales > (ms1.total_sales + ms2.total_sales)
ORDER BY ms.order_month;
