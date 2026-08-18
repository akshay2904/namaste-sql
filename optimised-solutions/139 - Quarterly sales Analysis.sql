-- ======================================================================
-- 139 - Quarterly sales Analysis
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Microsoft
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/139-quarterly-sales-analysis
-- ======================================================================

/*
Given a sales dataset that records daily transactions for various products, write an SQL query to calculate last quarter's total sales and quarter-to-date (QTD) sales for each product, helping analyze past performance and current trends.

 
Table: sales
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| product_id  | int      | 
| sale_date   | date     | 
| sales_amount | int      | 
+-------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH current_date_info AS (
    -- Calculate current quarter boundaries once
    SELECT
        CURRENT_DATE AS today,
        DATE_TRUNC('quarter', CURRENT_DATE) AS current_quarter_start,
        DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '1 day' AS last_quarter_end,
        DATE_TRUNC('quarter', DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '1 day') AS last_quarter_start
),
aggregated AS (
    SELECT
        s.product_id,
        -- QTD: from start of current quarter to today
        SUM(CASE 
            WHEN s.sale_date >= cdi.current_quarter_start 
             AND s.sale_date <= cdi.today 
            THEN s.sales_amount ELSE 0 
        END) AS qtd_sales,
        -- Last quarter: full previous quarter
        SUM(CASE 
            WHEN s.sale_date >= cdi.last_quarter_start 
             AND s.sale_date <= cdi.last_quarter_end 
            THEN s.sales_amount ELSE 0 
        END) AS last_quarter_sales
    FROM sales s
    CROSS JOIN current_date_info cdi
    -- Only scan relevant rows (last quarter start up to today)
    WHERE s.sale_date >= cdi.last_quarter_start
      AND s.sale_date <= cdi.today
    GROUP BY s.product_id
)
SELECT
    product_id,
    COALESCE(last_quarter_sales, 0) AS last_quarter_total_sales,
    COALESCE(qtd_sales, 0)          AS quarter_to_date_sales,
    -- Optional: growth indicator comparing QTD pace vs last quarter
    ROUND(
        CASE 
            WHEN last_quarter_sales > 0 
            THEN (qtd_sales::NUMERIC / last_quarter_sales) * 100 
            ELSE NULL 
        END, 2
    ) AS qtd_vs_last_quarter_pct
FROM aggregated
ORDER BY product_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    p.product_id,
    COALESCE(lq.last_quarter_total_sales, 0) AS last_quarter_total_sales,
    COALESCE(qtd.quarter_to_date_sales, 0)   AS quarter_to_date_sales,
    ROUND(
        CASE 
            WHEN COALESCE(lq.last_quarter_total_sales, 0) > 0 
            THEN (COALESCE(qtd.quarter_to_date_sales, 0)::NUMERIC 
                  / lq.last_quarter_total_sales) * 100
            ELSE NULL 
        END, 2
    ) AS qtd_vs_last_quarter_pct
FROM (
    -- Get all distinct products
    SELECT DISTINCT product_id FROM sales
) p
LEFT JOIN (
    -- Last quarter total sales per product
    SELECT
        product_id,
        SUM(sales_amount) AS last_quarter_total_sales
    FROM sales
    WHERE sale_date >= DATE_TRUNC('quarter', 
                            DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '1 day')
      AND sale_date <  DATE_TRUNC('quarter', CURRENT_DATE)
    GROUP BY product_id
) lq ON p.product_id = lq.product_id
LEFT JOIN (
    -- Quarter-to-date sales per product (current quarter so far)
    SELECT
        product_id,
        SUM(sales_amount) AS quarter_to_date_sales
    FROM sales
    WHERE sale_date >= DATE_TRUNC('quarter', CURRENT_DATE)
      AND sale_date <= CURRENT_DATE
    GROUP BY product_id
) qtd ON p.product_id = qtd.product_id
ORDER BY p.product_id;
