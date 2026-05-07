-- ======================================================================
-- 68 - Late Food Deliveries
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Zomato
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/68-late-food-deliveries
-- ======================================================================

/*
You’re analyzing late deliveries on Zomato. Each order’s total delivery time is split equally:

50% for food preparation (restaurant)

50% for the rider's trip

Goal: Find orders that were late ONLY because the rider took longer than expected. In other words, food was ready on time, but the rider was slow.

Display the following for each such order:

order_id

expected_delivery_mins

rider_delivery_mins

food_prep_mins

Sort the results by order_id in ascending order.

 
Table: orders
+------------------------+-----------+
| COLUMN_NAME            | DATA_TYPE |
+------------------------+-----------+
| order_id               | int       |
| restaurant_id          | int       |
| order_time             | time      |
| expected_delivery_time | time      |
| actual_delivery_time   | time      |
| rider_delivery_mins    | int       |
+------------------------+-----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    order_id,
    CAST(EXTRACT(EPOCH FROM (expected_delivery_time - order_time)) / 60 AS INT) AS expected_delivery_mins,
    rider_delivery_mins,
    CAST(EXTRACT(EPOCH FROM (expected_delivery_time - order_time)) / 60 AS INT) / 2 AS food_prep_mins
FROM orders
WHERE 
    -- Total delivery time exceeded expected time
    EXTRACT(EPOCH FROM (actual_delivery_time - order_time)) / 60 > EXTRACT(EPOCH FROM (expected_delivery_time - order_time)) / 60
    -- But rider delivery time exceeded the expected 50% threshold
    AND rider_delivery_mins > CAST(EXTRACT(EPOCH FROM (expected_delivery_time - order_time)) / 60 AS INT) / 2
    -- And food prep was on time (actual prep time <= expected 50%)
    AND EXTRACT(EPOCH FROM (actual_delivery_time - order_time)) / 60 - rider_delivery_mins <= CAST(EXTRACT(EPOCH FROM (expected_delivery_time - order_time)) / 60 AS INT) / 2
ORDER BY order_id ASC;
```
