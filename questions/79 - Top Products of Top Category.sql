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

```sql
-- Step 1: Find the top-selling category by total sales
-- Step 2: Get top 3 products from that category
WITH category_sales AS (
  SELECT 
    category,
    SUM(amount) as total_category_sales
  FROM orders
  GROUP BY category
  ORDER BY total_category_sales DESC
  LIMIT 1
),
product_sales AS (
  SELECT 
    product_id,
    category,
    SUM(amount) as total_product_sales
  FROM orders
  WHERE category = (SELECT category FROM category_sales)
  GROUP BY product_id, category
)
SELECT 
  product_id,
  category,
  total_product_sales
FROM product_sales
ORDER BY total_product_sales DESC
LIMIT 3;
```
