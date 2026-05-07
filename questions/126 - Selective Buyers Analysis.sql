-- ======================================================================
-- 126 - Selective Buyers Analysis
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Flipkart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/126-selective-buyers-analysis
-- ======================================================================

/*
You are given an orders table that contains information about customer purchases, including the products they bought. Write a query to find all customers who have purchased both "Laptop" and "Mouse", but have never purchased "Phone Case". Additionally, include the total number of distinct products purchased by these customers. Sort the result by customer id.

 
Table: orders 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| customer_id | int      |
| order_id    | int      |
| product_name| varchar  |
+-------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    customer_id,
    COUNT(DISTINCT product_name) AS total_distinct_products
FROM orders
GROUP BY customer_id
HAVING 
    SUM(CASE WHEN product_name = 'Laptop' THEN 1 ELSE 0 END) > 0
    AND SUM(CASE WHEN product_name = 'Mouse' THEN 1 ELSE 0 END) > 0
    AND SUM(CASE WHEN product_name = 'Phone Case' THEN 1 ELSE 0 END) = 0
ORDER BY customer_id;
```
