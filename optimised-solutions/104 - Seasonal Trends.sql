-- ======================================================================
-- 104 - Seasonal Trends
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Flipkart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/104-seasonal-trends
-- ======================================================================

/*
You're working for a retail company that sells various products. The company wants to identify seasonal trends in sales for its top-selling products across different regions. They are particularly interested in understanding the variation in sales volume across seasons for these products.
For each top-selling product in each region, calculate the total quantity sold for each season (spring, summer, autumn, winter) in 2023, display the output in ascending order of region name, product name & season name.

 
Table: products
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| product_id   | int         |
| product_name | varchar(10) |
+--------------+-------------+Table: sales
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| sale_id       | int         |
| product_id    | int         |
| region_name   | varchar(20) |
| sale_date     | date        |
| quantity_sold | int         |
+---------------+-------------+Table: seasons
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| start_date  | date        |
| end_date    | date        |
| season_name | varchar(10) |
+-------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH sales_2023 AS (
    -- Filter sales to 2023 once and join with season info
    SELECT 
        s.product_id,
        s.region_name,
        se.season_name,
        s.quantity_sold
    FROM sales s
    JOIN seasons se 
        ON s.sale_date BETWEEN se.start_date AND se.end_date
    WHERE EXTRACT(YEAR FROM s.sale_date) = 2023
),
regional_product_totals AS (
    -- Calculate total quantity per product per region
    SELECT 
        product_id,
        region_name,
        SUM(quantity_sold) AS total_qty
    FROM sales_2023
    GROUP BY product_id, region_name
),
top_sellers AS (
    -- Identify top-selling product per region using RANK()
    SELECT 
        product_id,
        region_name
    FROM (
        SELECT 
            product_id,
            region_name,
            RANK() OVER (PARTITION BY region_name ORDER BY total_qty DESC) AS rnk
        FROM regional_product_totals
    ) ranked
    WHERE rnk = 1
),
seasonal_sales AS (
    -- Aggregate seasonal quantities for top sellers only
    SELECT 
        s.region_name,
        s.product_id,
        s.season_name,
        SUM(s.quantity_sold) AS total_quantity_sold
    FROM sales_2023 s
    INNER JOIN top_sellers ts 
        ON s.product_id = ts.product_id 
       AND s.region_name = ts.region_name
    GROUP BY s.region_name, s.product_id, s.season_name
)
SELECT 
    ss.region_name,
    p.product_name,
    ss.season_name,
    ss.total_quantity_sold
FROM seasonal_sales ss
JOIN products p ON ss.product_id = p.product_id
ORDER BY ss.region_name, p.product_name, ss.season_name;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    s.region_name,
    p.product_name,
    se.season_name,
    SUM(s.quantity_sold) AS total_quantity_sold
FROM sales s
JOIN products p 
    ON s.product_id = p.product_id
JOIN seasons se 
    ON s.sale_date BETWEEN se.start_date AND se.end_date
WHERE EXTRACT(YEAR FROM s.sale_date) = 2023
  AND s.product_id IN (
      -- Find the top-selling product(s) per region by total quantity in 2023
      SELECT product_id
      FROM sales inner_s
      WHERE EXTRACT(YEAR FROM inner_s.sale_date) = 2023
        AND inner_s.region_name = s.region_name
      GROUP BY product_id
      HAVING SUM(quantity_sold) = (
          -- Get the maximum total quantity for any product in this region
          SELECT MAX(region_product_totals.total_qty)
          FROM (
              SELECT 
                  product_id,
                  SUM(quantity_sold) AS total_qty
              FROM sales innermost_s
              WHERE EXTRACT(YEAR FROM innermost_s.sale_date) = 2023
                AND innermost_s.region_name = s.region_name
              GROUP BY product_id
          ) region_product_totals
      )
  )
GROUP BY s.region_name, p.product_name, se.season_name
ORDER BY s.region_name, p.product_name, se.season_name;
