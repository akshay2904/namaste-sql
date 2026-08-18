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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH room_date_bookings AS (
    -- Join bookings to calendar to expand each booking into individual dates
    -- check_out_date is exclusive, so cal_date < check_out_date
    SELECT
        b.room_id,
        c.cal_date AS booking_date,
        b.customer_id
    FROM bookings b
    JOIN calendar_dim c
        ON c.cal_date >= b.check_in_date
        AND c.cal_date < b.check_out_date
),
overlapping_dates AS (
    -- Identify room+date combinations that have more than one customer
    SELECT
        room_id,
        booking_date,
        COUNT(customer_id) AS booking_count
    FROM room_date_bookings
    GROUP BY room_id, booking_date
    HAVING COUNT(customer_id) > 1
)
SELECT
    rdb.room_id,
    rdb.booking_date,
    rdb.customer_id
FROM room_date_bookings rdb
-- Only keep rows where the room+date has overlapping bookings
JOIN overlapping_dates od
    ON rdb.room_id = od.room_id
    AND rdb.booking_date = od.booking_date
ORDER BY
    rdb.room_id,
    rdb.booking_date,
    rdb.customer_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    b.room_id,
    c.cal_date AS booking_date,
    b.customer_id
FROM bookings b
JOIN calendar_dim c
    ON c.cal_date >= b.check_in_date
    AND c.cal_date < b.check_out_date
WHERE
    -- Filter to only dates/rooms where more than one customer is booked
    (b.room_id, c.cal_date) IN (
        SELECT
            b2.room_id,
            c2.cal_date
        FROM bookings b2
        JOIN calendar_dim c2
            ON c2.cal_date >= b2.check_in_date
            AND c2.cal_date < b2.check_out_date
        GROUP BY
            b2.room_id,
            c2.cal_date
        HAVING COUNT(b2.customer_id) > 1
    )
ORDER BY
    b.room_id,
    c.cal_date,
    b.customer_id;
