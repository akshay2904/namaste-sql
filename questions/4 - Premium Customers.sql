-- ======================================================================
-- 4 - Premium Customers
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/4-premium-customers
-- ======================================================================

/*
An e-commerce company want to start special reward program for their premium customers.  The customers who have placed a greater number of orders than the average number of orders placed by customers are considered as premium customers.

 

Write an SQL to find the list of premium customers along with the number of orders placed by each of them, display the results in highest to lowest no of orders.

 
Table: orders (primary key : order_id)
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| order_id      | int         |
| order_date    | date        |
| customer_name | varchar(20) |
| sales         | int         |
+---------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    customer_name,
    COUNT(order_id) as number_of_orders
FROM orders
GROUP BY customer_name
HAVING COUNT(order_id) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(order_id) as order_count
        FROM orders
        GROUP BY customer_name
    ) subquery
)
ORDER BY number_of_orders DESC;
```
