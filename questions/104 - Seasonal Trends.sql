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

```sql
WITH sales_2023 AS (
  -- Filter sales for year 2023 and join with product and season info
  SELECT 
    s.product_id,
    p.product_name,
    s.region_name,
    s.quantity_sold,
    se.season_name
  FROM sales s
  JOIN products p ON s.product_id = p.product_id
  JOIN seasons se ON s.sale_date BETWEEN se.start_date AND se.end_date
  WHERE YEAR(s.sale_date) = 2023
),
product_sales_by_region AS (
  -- Calculate total quantity per product per region
  SELECT 
    region_name,
    product_id,
    product_name,
    SUM(quantity_sold) as total_quantity
  FROM sales_2023
  GROUP BY region_name, product_id, product_name
),
ranked_products AS (
  -- Rank products by sales volume within each region
  SELECT 
    region_name,
    product_id,
    product_name,
    total_quantity,
    ROW_NUMBER() OVER (PARTITION BY region_name ORDER BY total_quantity DESC) as rank
  FROM product_sales_by_region
),
top_products AS (
  -- Get only the top-selling product per region
  SELECT 
    region_name,
    product_id,
    product_name
  FROM ranked_products
  WHERE rank = 1
)
SELECT 
  tp.region_name,
  tp.product_name,
  s2023.season_name,
  SUM(s2023.quantity_sold) as total_quantity_sold
FROM top_products tp
JOIN sales_2023 s2023 
  ON tp.product_id = s2023.product_id 
  AND tp.region_name = s2023.region_name
GROUP BY tp.region_name, tp.product_name, s2023.season_name
ORDER BY tp.region_name ASC, tp.product_name ASC, s2023.season_name ASC;
```
