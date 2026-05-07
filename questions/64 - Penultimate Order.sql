-- ======================================================================
-- 64 - Penultimate Order
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Walmart
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/64-penultimate-order
-- ======================================================================

/*
You are a data analyst working for an e-commerce company, responsible for analysing customer orders to gain insights into their purchasing behaviour. Your task is to write a SQL query to retrieve the details of the penultimate order for each customer. However, if a customer has placed only one order, you need to retrieve the details of that order instead, display the output in ascending order of customer name.

 
Table: orders
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| order_id      | int         |
| order_date    | date        |
| customer_name | varchar(10) |
| product_name  | varchar(50) |
| sales         | int         |
+---------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
  order_id,
  order_date,
  customer_name,
  product_name,
  sales
FROM (
  SELECT 
    order_id,
    order_date,
    customer_name,
    product_name,
    sales,
    ROW_NUMBER() OVER (PARTITION BY customer_name ORDER BY order_date DESC) AS rn,
    COUNT(*) OVER (PARTITION BY customer_name) AS total_orders
  FROM orders
) ranked_orders
WHERE 
  (total_orders = 1 AND rn = 1)
  OR (total_orders > 1 AND rn = 2)
ORDER BY customer_name ASC;
```
