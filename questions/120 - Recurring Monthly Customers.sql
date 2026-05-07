-- ======================================================================
-- 120 - Recurring Monthly Customers
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Zepto
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/120-recurring-monthly-customers
-- ======================================================================

/*
In a quick commerce business, Analyzing the frequency and timing of purchases can help the company identify engaged customers and tailor promotions accordingly.

You are tasked to identify customers who have made a minimum of three purchases, ensuring that each purchase occurred in a different month. This information will assist in targeting marketing efforts towards customers who show consistent buying behavior over time.

Write an SQL to display customer id and no of orders placed by them.

 
Table: orders 
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| customer_id   | int       |
| order_id      | int       |
| order_date    | date      |
+---------------+-----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    customer_id,
    COUNT(order_id) AS no_of_orders
FROM orders
GROUP BY customer_id
HAVING 
    COUNT(order_id) >= 3
    AND COUNT(DISTINCT YEAR(order_date) * 100 + MONTH(order_date)) >= 3
ORDER BY no_of_orders DESC;
```
