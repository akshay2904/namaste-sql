-- ======================================================================
-- 1 - Return Orders Customer Feedback
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/1-return-orders-customer-feedback
-- ======================================================================

/*
Namastekart, an e-commerce company, has observed a notable surge in return orders recently. They suspect that a specific group of customers may be responsible for a significant portion of these returns. To address this issue, their initial goal is to identify customers who have returned more than 50% of their orders. This way, they can proactively reach out to these customers to gather feedback.

 

Write an SQL to find list of customers along with their return percent (Round to 2 decimal places), display the output in ascending order of customer name.

Table: orders (primary key : order_id)
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| customer_name | varchar(10) |
| order_date    | date        |
| order_id      | int         |
| sales         | int         |
+---------------+-------------+

Table: returns (primary key : order_id)
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_id    | int       |
| return_date | date      |
+-------------+-----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
  o.customer_name,
  ROUND(100.0 * COUNT(r.order_id) / COUNT(o.order_id), 2) AS return_percent
FROM orders o
LEFT JOIN returns r ON o.order_id = r.order_id
GROUP BY o.customer_name
HAVING COUNT(r.order_id) * 100.0 / COUNT(o.order_id) > 50
ORDER BY o.customer_name ASC;
```
