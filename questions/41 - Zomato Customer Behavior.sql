-- ======================================================================
-- 41 - Zomato Customer Behavior
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Zomato
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/41-zomato-customer-behavior
-- ======================================================================

/*
Suppose you are a data analyst working for Zomato (a online food delivery company) . Zomato is interested in analysing customer food ordering behavior and wants to identify customers who have exhibited inconsistent patterns over time.

Your task is to write an SQL query to identify customers who have placed orders on both weekdays and weekends, but with a significant difference in the average order amount between weekdays and weekends. Specifically, you need to identify customers who have a minimum of 3 orders placed both on weekdays and weekends each, and where the average order amount on weekends is at least 20% higher than the average order amount on weekdays.

Your query should return the customer id, the average order amount on weekends, the average order amount on weekdays, and the percentage difference (round to 2 decimal places) in average order amount between weekends and weekdays for each customer meeting the criteria.

 
Table: orders
+--------------+---------------+
| COLUMN_NAME  | DATA_TYPE     |
+--------------+---------------+
| order_id     | int           |
| customer_id  | int           |
| order_amount | decimal(10,2) |
| order_date   | date          |
+--------------+---------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    customer_id,
    ROUND(weekend_avg, 2) AS weekend_avg_order_amount,
    ROUND(weekday_avg, 2) AS weekday_avg_order_amount,
    ROUND(((weekend_avg - weekday_avg) / weekday_avg) * 100, 2) AS percentage_difference
FROM (
    SELECT 
        customer_id,
        AVG(CASE WHEN DAYOFWEEK(order_date) IN (1, 7) THEN order_amount END) AS weekend_avg,
        AVG(CASE WHEN DAYOFWEEK(order_date) NOT IN (1, 7) THEN order_amount END) AS weekday_avg,
        COUNT(CASE WHEN DAYOFWEEK(order_date) IN (1, 7) THEN 1 END) AS weekend_count,
        COUNT(CASE WHEN DAYOFWEEK(order_date) NOT IN (1, 7) THEN 1 END) AS weekday_count
    FROM orders
    GROUP BY customer_id
) subquery
WHERE weekend_count >= 3 
    AND weekday_count >= 3 
    AND weekend_avg >= weekday_avg * 1.20
ORDER BY percentage_difference DESC;
```
