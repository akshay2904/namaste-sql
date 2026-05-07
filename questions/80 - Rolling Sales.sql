-- ======================================================================
-- 80 - Rolling Sales
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Walmart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/80-rolling-sales
-- ======================================================================

/*
You are tasked with analysing the sales data for products during the month of January 2024. Your goal is to calculate the rolling sum of sales for each product and each day of Jan 2024, considering the sales for the current day and the two previous days. Note that for some days, there might not be any sales for certain products, and you need to consider these days as having sales of 0.

You can make use of the calendar table which has the all the dates for Jan-2024.

 
Tables: orders
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| amount      | int        |
| order_date  | date       |
| order_id    | int        |
| product_id  | varchar(5) |
+-------------+------------+Tables: calendar_dim
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| cal_date    | date      |
+-------------+-----------+
*/


-- Write your SQL solution below:

```sql
WITH daily_sales AS (
  -- Get daily sales per product, filling in missing days with 0
  SELECT 
    c.cal_date,
    o.product_id,
    COALESCE(SUM(o.amount), 0) as daily_sales
  FROM calendar_dim c
  CROSS JOIN (SELECT DISTINCT product_id FROM orders) p
  LEFT JOIN orders o 
    ON c.cal_date = o.order_date 
    AND p.product_id = o.product_id
  GROUP BY c.cal_date, p.product_id
),
rolling_sum AS (
  -- Calculate 3-day rolling sum (current day + 2 previous days)
  SELECT 
    cal_date,
    product_id,
    daily_sales,
    SUM(daily_sales) OVER (
      PARTITION BY product_id 
      ORDER BY cal_date 
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as rolling_sum_3days
  FROM daily_sales
)
SELECT 
  cal_date,
  product_id,
  daily_sales,
  rolling_sum_3days
FROM rolling_sum
ORDER BY product_id, cal_date;
```
