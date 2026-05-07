-- ======================================================================
-- 45 - Zomato Membership
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Zomato
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/45-zomato-membership
-- ======================================================================

/*
Zomato is planning to offer a premium membership to customers who have placed multiple orders in a single day.

Your task is to write a SQL to find those customers who have placed multiple orders in a single day at least once , total order value generate by those customers and order value generated only by those orders, display the results in ascending order of total order value.

 
Table: orders (primary key : order_id)
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| customer_name | varchar(20) |
| order_date    | datetime    |
| order_id      | int         |
| order_value   | int         |
+---------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    customer_name,
    SUM(order_value) AS total_order_value,
    SUM(CASE 
        WHEN DATE(order_date) IN (
            SELECT DATE(order_date)
            FROM orders o2
            WHERE o2.customer_name = orders.customer_name
            GROUP BY DATE(order_date)
            HAVING COUNT(*) > 1
        ) THEN order_value
        ELSE 0
    END) AS multi_order_day_value
FROM orders
WHERE customer_name IN (
    SELECT customer_name
    FROM orders
    GROUP BY customer_name, DATE(order_date)
    HAVING COUNT(*) > 1
)
GROUP BY customer_name
ORDER BY total_order_value ASC;
```
