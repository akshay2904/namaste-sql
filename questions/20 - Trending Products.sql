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

```sql
WITH monthly_sales AS (
  SELECT 
    order_month,
    product_id,
    sales,
    LAG(sales, 1) OVER (PARTITION BY product_id ORDER BY order_month) AS prev_month_sales,
    LAG(sales, 2) OVER (PARTITION BY product_id ORDER BY order_month) AS prev_2_months_sales
  FROM orders
),
ranked_months AS (
  SELECT 
    order_month,
    product_id,
    sales,
    prev_month_sales,
    prev_2_months_sales,
    ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY order_month) AS month_rank
  FROM monthly_sales
)
SELECT 
  order_month,
  product_id
FROM ranked_months
WHERE month_rank >= 3
  AND sales > (COALESCE(prev_month_sales, 0) + COALESCE(prev_2_months_sales, 0))
ORDER BY order_month;
```
