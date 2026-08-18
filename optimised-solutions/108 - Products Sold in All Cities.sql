-- ======================================================================
-- 108 - Products Sold in All Cities
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Flipkart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/108-products-sold-in-all-cities
-- ======================================================================

/*
A technology company operates in several major cities across India, selling a variety of tech products. The company wants to analyze its sales data to understand which products have been successfully sold in all the cities where they operate(available in cities table).
Write an SQL query to identify the product names that have been sold at least 2 times in every city where the company operates.

 
Table: products
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| product_id  | int        |
| product_name| VARCHAR(12)|
+-------------+------------+Table: cities
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| city_id     | int        |
| city_name   | VARCHAR(10)|
+-------------+------------+Table: sales
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| sale_id     | int        |
| product_id  | int        |
| city_id     | int        |
| sale_date   | VARCHAR(12)|
| quantity    | int        |
+-------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH city_product_sales AS (
    -- Aggregate sales count per product per city
    SELECT
        s.product_id,
        s.city_id,
        COUNT(*) AS sale_count
    FROM sales s
    GROUP BY s.product_id, s.city_id
),
qualifying_cities AS (
    -- Keep only product-city combos where sold at least 2 times
    SELECT product_id, city_id
    FROM city_product_sales
    WHERE sale_count >= 2
),
total_cities AS (
    SELECT COUNT(*) AS total FROM cities
),
product_city_counts AS (
    -- Count distinct cities each product qualifies in, using window function
    SELECT
        product_id,
        COUNT(city_id) AS qualified_city_count,
        MAX(total) AS total_city_count
    FROM qualifying_cities
    CROSS JOIN total_cities
    GROUP BY product_id
)
SELECT p.product_name
FROM product_city_counts pcc
JOIN products p ON p.product_id = pcc.product_id
WHERE pcc.qualified_city_count = pcc.total_city_count
ORDER BY p.product_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT p.product_name
FROM products p
WHERE p.product_id IN (
    -- Products that have >= 2 sales in every city
    SELECT s.product_id
    FROM sales s
    JOIN cities c ON c.city_id = s.city_id  -- only consider cities that operate
    GROUP BY s.product_id, s.city_id
    HAVING COUNT(*) >= 2                    -- at least 2 sales in this city
    GROUP BY s.product_id                   -- this won't work; use subquery below
)

-- Corrected brute force:
SELECT p.product_name
FROM products p
WHERE p.product_id IN (
    SELECT product_id
    FROM (
        -- Count sales per product per city (only for operating cities)
        SELECT s.product_id, s.city_id, COUNT(*) AS sale_count
        FROM sales s
        WHERE s.city_id IN (SELECT city_id FROM cities)
        GROUP BY s.product_id, s.city_id
    ) city_sales
    WHERE sale_count >= 2
    GROUP BY product_id
    -- The product must qualify in as many cities as the total operating cities
    HAVING COUNT(DISTINCT city_id) = (SELECT COUNT(*) FROM cities)
)
ORDER BY p.product_name;
