-- ======================================================================
-- 75 - Rider Ride Time
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Swiggy
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/75-rider-ride-time
-- ======================================================================

/*
You are working with Zomato, a food delivery platform, and you need to analyze the performance of Zomato riders in terms of the time they spend delivering orders each day. Given the pickup and delivery times for each order, your task is to calculate the duration of time spent by each rider on deliveries each day.  Order the output by rider id and ride date.

 
Table:orders 
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| rider_id      | int       |
| order_id      | int       |
| pickup_time   | datetime  |
| delivery_time | datetime  |
+---------------+-----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    rider_id,
    DATE(pickup_time) AS ride_date,
    EXTRACT(EPOCH FROM (MAX(delivery_time) - MIN(pickup_time))) / 3600 AS total_delivery_hours
FROM orders
GROUP BY rider_id, DATE(pickup_time)
ORDER BY rider_id, ride_date;
```
