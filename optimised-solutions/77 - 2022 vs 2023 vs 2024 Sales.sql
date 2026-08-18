-- ======================================================================
-- 77 - 2022 vs 2023 vs 2024 Sales
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Walmart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/77-2022-vs-2023-vs-2024-sales
-- ======================================================================

/*
You are tasked with analyzing the sales growth of products over the years 2022, 2023, and 2024. Your goal is to identify months where the sales for a product have consistently increased from 2022 to 2023 and from 2023 to 2024.
Your task is to write an SQL query to generate a report that includes the sales for each product at the month level for the years 2022, 2023, and 2024. However, you should only include product and months combination where the sales have consistently increased from 2022 to 2023 and from 2023 to 2024, display the output in ascending order of product_id.

 
Table: orders
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_id    | int       |
| customer_id | int       |
| order_date  | date      |
| product_id  | int       |
| sales       | int       |
+-------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_sales AS (
    SELECT
        product_id,
        EXTRACT(MONTH FROM order_date) AS month,
        EXTRACT(YEAR FROM order_date)  AS year,
        SUM(sales) AS total_sales
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) IN (2022, 2023, 2024)
    GROUP BY product_id, EXTRACT(MONTH FROM order_date), EXTRACT(YEAR FROM order_date)
),
pivoted AS (
    SELECT
        product_id,
        month,
        MAX(CASE WHEN year = 2022 THEN total_sales END) AS sales_2022,
        MAX(CASE WHEN year = 2023 THEN total_sales END) AS sales_2023,
        MAX(CASE WHEN year = 2024 THEN total_sales END) AS sales_2024
    FROM monthly_sales
    GROUP BY product_id, month
)
SELECT
    product_id,
    month,
    sales_2022,
    sales_2023,
    sales_2024
FROM pivoted
WHERE
    sales_2022 IS NOT NULL
    AND sales_2023 IS NOT NULL
    AND sales_2024 IS NOT NULL
    AND sales_2023 > sales_2022   -- consistent growth 2022 -> 2023
    AND sales_2024 > sales_2023   -- consistent growth 2023 -> 2024
ORDER BY product_id ASC, month ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    y2022.product_id,
    y2022.month,
    y2022.sales_2022,
    y2023.sales_2023,
    y2024.sales_2024
FROM
    -- Aggregate sales for 2022
    (
        SELECT
            product_id,
            EXTRACT(MONTH FROM order_date) AS month,
            SUM(sales) AS sales_2022
        FROM orders
        WHERE EXTRACT(YEAR FROM order_date) = 2022
        GROUP BY product_id, EXTRACT(MONTH FROM order_date)
    ) y2022
    -- Join with 2023 aggregates
    INNER JOIN (
        SELECT
            product_id,
            EXTRACT(MONTH FROM order_date) AS month,
            SUM(sales) AS sales_2023
        FROM orders
        WHERE EXTRACT(YEAR FROM order_date) = 2023
        GROUP BY product_id, EXTRACT(MONTH FROM order_date)
    ) y2023
        ON y2022.product_id = y2023.product_id
        AND y2022.month = y2023.month
    -- Join with 2024 aggregates
    INNER JOIN (
        SELECT
            product_id,
            EXTRACT(MONTH FROM order_date) AS month,
            SUM(sales) AS sales_2024
        FROM orders
        WHERE EXTRACT(YEAR FROM order_date) = 2024
        GROUP BY product_id, EXTRACT(MONTH FROM order_date)
    ) y2024
        ON y2022.product_id = y2024.product_id
        AND y2022.month = y2024.month
WHERE
    y2023.sales_2023 > y2022.sales_2022   -- consistent growth 2022 -> 2023
    AND y2024.sales_2024 > y2023.sales_2023 -- consistent growth 2023 -> 2024
ORDER BY y2022.product_id ASC, y2022.month ASC;
