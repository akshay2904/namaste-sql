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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH jan_bookings AS (
    -- Calculate occupancy days for each booking in January 2023
    SELECT
        b.listing_id,
        -- Clamp the booking period to January 2023 boundaries
        LEAST(b.checkout_date, DATE '2023-01-31') - GREATEST(b.checkin_date, DATE '2023-01-01') AS occupancy_days
    FROM bookings b
    WHERE b.checkin_date <= DATE '2023-01-31'
      AND b.checkout_date >= DATE '2023-01-01'
),
avg_occupancy AS (
    -- Average occupancy days per location and room type
    SELECT
        l.location,
        l.room_type,
        ROUND(AVG(jb.occupancy_days)::NUMERIC, 2) AS avg_occupancy_days,
        -- Rank room types within each location by avg occupancy (highest first)
        RANK() OVER (
            PARTITION BY l.location
            ORDER BY AVG(jb.occupancy_days) DESC
        ) AS rnk
    FROM listings l
    JOIN jan_bookings jb ON l.listing_id = jb.listing_id
    GROUP BY l.location, l.room_type
)
SELECT
    location,
    room_type,
    avg_occupancy_days
FROM avg_occupancy
WHERE rnk = 1
ORDER BY avg_occupancy_days DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Step 1: Calculate avg occupancy per location + room_type for Jan 2023
-- Step 2: For each location, find the max of those averages
-- Step 3: Return only the room type(s) matching that max

SELECT
    loc_rt.location,
    loc_rt.room_type,
    loc_rt.avg_occupancy_days
FROM (
    SELECT
        l.location,
        l.room_type,
        ROUND(AVG(
            LEAST(b.checkout_date, DATE '2023-01-31') -
            GREATEST(b.checkin_date, DATE '2023-01-01')
        )::NUMERIC, 2) AS avg_occupancy_days
    FROM listings l
    JOIN bookings b ON l.listing_id = b.listing_id
    WHERE b.checkin_date  <= DATE '2023-01-31'
      AND b.checkout_date >= DATE '2023-01-01'
    GROUP BY l.location, l.room_type
) loc_rt
WHERE loc_rt.avg_occupancy_days = (
    -- Find the maximum average occupancy for that location
    SELECT MAX(sub.avg_occ)
    FROM (
        SELECT
            l2.location,
            AVG(
                LEAST(b2.checkout_date, DATE '2023-01-31') -
                GREATEST(b2.checkin_date, DATE '2023-01-01')
            ) AS avg_occ
        FROM listings l2
        JOIN bookings b2 ON l2.listing_id = b2.listing_id
        WHERE b2.checkin_date  <= DATE '2023-01-31'
          AND b2.checkout_date >= DATE '2023-01-01'
        GROUP BY l2.location, l2.room_type
    ) sub
    WHERE sub.location = loc_rt.location
)
ORDER BY loc_rt.avg_occupancy_days DESC;
