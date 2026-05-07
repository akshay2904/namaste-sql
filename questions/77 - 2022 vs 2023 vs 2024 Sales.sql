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

```sql
WITH monthly_sales AS (
  -- Aggregate sales by product, year, and month
  SELECT 
    product_id,
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(sales) AS total_sales
  FROM orders
  WHERE EXTRACT(YEAR FROM order_date) IN (2022, 2023, 2024)
  GROUP BY product_id, EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
),
pivoted_sales AS (
  -- Pivot sales by year for each product and month combination
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
FROM pivoted_sales
WHERE 
  -- Ensure all three years have data and sales consistently increased
  sales_2022 IS NOT NULL
  AND sales_2023 IS NOT NULL
  AND sales_2024 IS NOT NULL
  AND sales_2022 < sales_2023
  AND sales_2023 < sales_2024
ORDER BY product_id ASC, month ASC;
```
