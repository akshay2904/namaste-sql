-- ======================================================================
-- 129 - Uber Active Drivers
-- ======================================================================
-- Difficulty : Extreme Hard
-- Category   : Analytics
-- Companies  : Uber
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/129-uber-active-drivers
-- ======================================================================

/*
We have a driver table which has driver id and join date for each Uber drivers. We have another table rides where we have ride id, ride date and driver id.  A driver becomes inactive if he doesn't have any ride for consecutive 28 days after joining the company. Driver can become active again once he takes a new ride. We need to find number of active drivers for uber at the end of each month for year 2023.

For example if a driver joins Uber on Jan 15th and takes his first ride on March 15th. He will be considered active for Jan month end , Not active for Feb month end but active for March month end.
Table: drivers 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| driver_id     | int      |
| join_date     | date     |
+-------------+------------+Table: rides 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| ride_id       | int      |
| ride_date     | date     |
| driver_id     | date     |
+-------------+------------+Table: calendar_dim (Contains all dates of 2023) 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| cal_date      | date     |
+-------------+------------+
*/


-- Write your SQL solution below:

```sql
WITH driver_status AS (
  -- For each driver, determine their activity status on each month-end date in 2023
  SELECT 
    d.driver_id,
    d.join_date,
    CAST(DATE_TRUNC('month', c.cal_date) + INTERVAL '1 month' - INTERVAL '1 day' AS DATE) AS month_end_date,
    -- Check if driver has a ride within 28 days before or on the month_end_date
    CASE 
      WHEN d.join_date > DATE_TRUNC('month', c.cal_date) + INTERVAL '1 month' - INTERVAL '1 day'
        THEN 0 -- Driver hasn't joined yet by month end
      WHEN EXISTS (
        SELECT 1 FROM rides r 
        WHERE r.driver_id = d.driver_id 
        AND r.ride_date <= DATE_TRUNC('month', c.cal_date) + INTERVAL '1 month' - INTERVAL '1 day'
        AND r.ride_date > (DATE_TRUNC('month', c.cal_date) + INTERVAL '1 month' - INTERVAL '1 day') - INTERVAL '28 days'
      ) THEN 1 -- Has a ride within last 28 days
      ELSE 0 -- Inactive (no ride for 28+ days)
    END AS is_active
  FROM drivers d
  CROSS JOIN (
    SELECT DISTINCT DATE_TRUNC('month', cal_date) AS month_date
    FROM calendar_dim
    WHERE EXTRACT(YEAR FROM cal_date) = 2023
  ) c
)
SELECT 
  month_end_date,
  COUNT(CASE WHEN is_active = 1 THEN driver_id END) AS active_drivers
FROM driver_status
WHERE is_active = 1
GROUP BY month_end_date
ORDER BY month_end_date;
```
