-- ======================================================================
-- 78 - Hotel Booking Mistake
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Makemytrip
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/78-hotel-booking-mistake
-- ======================================================================

/*
A hotel has accidentally made overbookings for certain rooms on specific dates. Due to this error, some rooms have been assigned to multiple customers for overlapping periods, leading to potential conflicts. The hotel management needs to rectify this mistake by contacting the affected customers and providing them with alternative arrangements.

 

Your task is to write an SQL query to identify the overlapping bookings for each room and determine the list of customers affected by these overlaps. For each room and overlapping date, the query should list the customers who have booked the room for that date. 
 

A booking's check-out date is not inclusive, meaning that if a room is booked from April 1st to April 4th, it is considered occupied from April 1st to April 3rd , another customer can check-in on April 4th and that will not be considered as overlap.
 

Order the result by room id, booking date. You may use calendar dim table which has all the dates for the year April 2024.

 
Table : bookings
+----------------+-----------+
| COLUMN_NAME    | DATA_TYPE |
+----------------+-----------+
| room_id        | int       |
| customer_id    | int       |
| check_in_date  | date      |
| check_out_date | date      |
+----------------+-----------+Table : calendar_dim
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| cal_date    | date      |
+-------------+-----------+
*/


-- Write your SQL solution below:

```sql
WITH booking_dates AS (
  -- Expand each booking to individual dates (check_out_date is exclusive)
  SELECT 
    b.room_id,
    b.customer_id,
    cd.cal_date AS booking_date
  FROM bookings b
  INNER JOIN calendar_dim cd 
    ON cd.cal_date >= b.check_in_date 
    AND cd.cal_date < b.check_out_date
),
overlapping_dates AS (
  -- Identify dates with multiple customers booked for the same room
  SELECT 
    room_id,
    booking_date
  FROM booking_dates
  GROUP BY room_id, booking_date
  HAVING COUNT(DISTINCT customer_id) > 1
)
-- Return all customers affected by overlaps, ordered by room and date
SELECT 
  bd.room_id,
  bd.booking_date,
  bd.customer_id
FROM booking_dates bd
INNER JOIN overlapping_dates od
  ON bd.room_id = od.room_id
  AND bd.booking_date = od.booking_date
ORDER BY bd.room_id, bd.booking_date;
```
