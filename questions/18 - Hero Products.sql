-- ======================================================================
-- 18 - Hero Products
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Flipkart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/18-hero-products
-- ======================================================================

/*
Flipkart an ecommerce company wants to find out its top most selling product by quantity in each category. In case of a tie when quantities sold are same for more than 1 product, then we need to give preference to the product with higher sales value.

Display category and product in output with category in ascending order.

 
Table: orders
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| category    | varchar(50) |
| order_id    | int         |
| product_id  | varchar(20) |
| quantity    | int         |
| unit_price  | int         |
+-------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    category,
    product_id
FROM (
    SELECT 
        category,
        product_id,
        SUM(quantity) AS total_quantity,
        SUM(quantity * unit_price) AS total_sales_value,
        ROW_NUMBER() OVER (
            PARTITION BY category 
            ORDER BY SUM(quantity) DESC, SUM(quantity * unit_price) DESC
        ) AS rnk
    FROM orders
    GROUP BY category, product_id
) ranked_products
WHERE rnk = 1
ORDER BY category ASC;
```
