-- ======================================================================
-- 36 - Airbnb Business
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Airbnb
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/36-airbnb-business
-- ======================================================================

/*
You are planning to list a property on Airbnb. To maximize profits, you need to analyze the Airbnb data for the month of January 2023 to determine the best room type for each location. The best room type is based on the maximum average occupancy during the given month.

Write an SQL query to find the best room type for each location based on the average occupancy days. Order the results in descending order of average occupancy days, rounded to 2 decimal places.

 
Table: listings
+----------------+---------------+
| COLUMN_NAME    | DATA_TYPE     |
+----------------+---------------+
| listing_id     | int           |
| host_id        | int           |
| location       | varchar(20)   |
| room_type      | varchar(20)   |
| price          | decimal(10,2) |
| minimum_nights | int           |
+----------------+---------------+Table: bookings
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| booking_id    | int       |
| checkin_date  | date      |
| checkout_date | date      |
| listing_id    | int       |
+---------------+-----------+
*/


-- Write your SQL solution below:

```sql
WITH january_2023_bookings AS (
  -- Filter bookings that overlap with January 2023
  SELECT 
    l.listing_id,
    l.location,
    l.room_type,
    -- Calculate occupancy days for each booking in January 2023
    LEAST(b.checkout_date, '2023-01-31') - GREATEST(b.checkin_date, '2023-01-01') AS occupancy_days
  FROM listings l
  INNER JOIN bookings b ON l.listing_id = b.listing_id
  WHERE b.checkin_date < '2023-02-01' 
    AND b.checkout_date > '2023-01-01'
),
avg_occupancy_by_room_type AS (
  -- Calculate average occupancy days by location and room type
  SELECT 
    location,
    room_type,
    ROUND(AVG(CAST(occupancy_days AS DECIMAL(10,2))), 2) AS avg_occupancy_days,
    -- Rank room types within each location by average occupancy
    ROW_NUMBER() OVER (PARTITION BY location ORDER BY AVG(CAST(occupancy_days AS DECIMAL(10,2))) DESC) AS rn
  FROM january_2023_bookings
  GROUP BY location, room_type
)
SELECT 
  location,
  room_type,
  avg_occupancy_days
FROM avg_occupancy_by_room_type
WHERE rn = 1
ORDER BY avg_occupancy_days DESC;
```
