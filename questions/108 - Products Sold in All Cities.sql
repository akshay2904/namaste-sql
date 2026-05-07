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

```sql
SELECT p.product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM cities c
    WHERE NOT EXISTS (
        SELECT 1
        FROM sales s
        WHERE s.product_id = p.product_id
        AND s.city_id = c.city_id
        GROUP BY s.product_id, s.city_id
        HAVING COUNT(*) >= 2
    )
)
GROUP BY p.product_id, p.product_name;
```
