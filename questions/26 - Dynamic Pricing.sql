-- ======================================================================
-- 26 - Dynamic Pricing
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Walmart
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/26-dynamic-pricing
-- ======================================================================

/*
You are given a products table where a new row is inserted every time the price of a product changes. Additionally, there is a transaction table containing details such as order_date and product_id for each order.

Write an SQL query to calculate the total sales value for each product, considering the cost of the product at the time of the order date, display the output in ascending order of the product_id.

 
Table: products
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| product_id  | int       |
| price       | int       |
| price_date  | date      |
+-------------+-----------+Table: orders 
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_id    | int       |
| order_date  | date      |
| product_id  | int       |
+-------------+-----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    o.product_id,
    SUM(p.price) AS total_sales
FROM orders o
INNER JOIN products p ON o.product_id = p.product_id
WHERE p.price_date <= o.order_date
    AND p.price_date = (
        -- Get the most recent price on or before the order date
        SELECT MAX(price_date)
        FROM products p2
        WHERE p2.product_id = o.product_id
            AND p2.price_date <= o.order_date
    )
GROUP BY o.product_id
ORDER BY o.product_id ASC;
```
