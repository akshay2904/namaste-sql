-- ======================================================================
-- 59 - Order Lead Time
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/59-order-lead-time
-- ======================================================================

/*
You are given orders data of an online ecommerce company. Dataset contains order_id , order_date and ship_date. Your task is to find lead time in days between order date and ship date using below rules:

 
1- Exclude holidays. List of holidays present in holiday table. 
2- If the order date is on weekends, then consider it as order placed on immediate next Monday 
and if the ship date is on weekends, then consider it as immediate previous Friday to do calculations.
For example, if order date is March 14th 2024 and ship date is March 20th 2024. Consider March 18th is a holiday then lead time will be (20-14) -1 holiday = 5 days.

Table: orders
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_date  | date      |
| order_id    | int       |
| ship_date   | date      |
+-------------+-----------+Table: holidays
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| holiday_date | date      |
| holiday_id   | int       |
+--------------+-----------+
*/


-- Write your SQL solution below:

```sql
WITH adjusted_dates AS (
  SELECT
    order_id,
    order_date,
    ship_date,
    -- Adjust order_date: if weekend, move to next Monday
    CASE
      WHEN EXTRACT(DOW FROM order_date) = 0 THEN order_date + INTERVAL '1 day'
      WHEN EXTRACT(DOW FROM order_date) = 6 THEN order_date + INTERVAL '2 days'
      ELSE order_date
    END AS adjusted_order_date,
    -- Adjust ship_date: if weekend, move to previous Friday
    CASE
      WHEN EXTRACT(DOW FROM ship_date) = 0 THEN ship_date - INTERVAL '2 days'
      WHEN EXTRACT(DOW FROM ship_date) = 6 THEN ship_date - INTERVAL '1 day'
      ELSE ship_date
    END AS adjusted_ship_date
  FROM orders
),
holiday_count AS (
  SELECT
    order_id,
    adjusted_order_date,
    adjusted_ship_date,
    COUNT(h.holiday_date) AS holidays_between
  FROM adjusted_dates ad
  LEFT JOIN holidays h
    ON h.holiday_date > ad.adjusted_order_date
    AND h.holiday_date < ad.adjusted_ship_date
  GROUP BY order_id, adjusted_order_date, adjusted_ship_date
)
SELECT
  order_id,
  -- Calculate lead time: difference in days minus holidays
  (adjusted_ship_date - adjusted_order_date) - holidays_between AS lead_time_days
FROM holiday_count;
```
