-- ======================================================================
-- 193 - Airline Bookings
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Hackerrank
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/193-airline-bookings
-- ======================================================================

/*
You are provided with data of airplane bookings which contain total seats in an airplane and the bookings done. Every airplane has some seats that are not booked. Find out the average number of seats that go without booking for every airline and fetch the airplanes for each airline whose number of empty seats is closest to the average number of seats that remain empty.

 

In case there are more than one airplane with same number of empty seats fetch them in order of airplane_id separated by comma. Also order the result by airline_id.

 

Schema : You are provided 2 tables: airlines_detail, bookings.
Table: airlines_detail
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| airplane_id  | INT       |
| airline_id   | INT       |
| total_seats  | INT       |
+--------------+-----------+Table: bookings
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| airplane_id  | INT       |
| booked       | INT       |
+--------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH empty_seats AS (
    -- Calculate empty seats per airplane
    SELECT
        ad.airplane_id,
        ad.airline_id,
        ad.total_seats - COALESCE(b.booked, 0) AS empty_seats
    FROM airlines_detail ad
    LEFT JOIN bookings b ON ad.airplane_id = b.airplane_id
),
avg_empty AS (
    -- Calculate average empty seats per airline using window function
    SELECT
        airplane_id,
        airline_id,
        empty_seats,
        AVG(empty_seats) OVER (PARTITION BY airline_id) AS avg_empty_seats
    FROM empty_seats
),
ranked AS (
    -- Rank airplanes by how close their empty seats are to the airline average
    SELECT
        airplane_id,
        airline_id,
        empty_seats,
        avg_empty_seats,
        RANK() OVER (
            PARTITION BY airline_id
            ORDER BY ABS(empty_seats - avg_empty_seats)
        ) AS rnk
    FROM avg_empty
)
SELECT
    airline_id,
    -- Aggregate airplane_ids with same closest empty seats, ordered by airplane_id
    STRING_AGG(airplane_id::TEXT, ',' ORDER BY airplane_id) AS airplane_ids,
    empty_seats,
    ROUND(avg_empty_seats, 2) AS avg_empty_seats
FROM ranked
WHERE rnk = 1
GROUP BY airline_id, empty_seats, avg_empty_seats
ORDER BY airline_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH empty_seats AS (
    -- Calculate empty seats per airplane
    SELECT
        ad.airplane_id,
        ad.airline_id,
        ad.total_seats - COALESCE(b.booked, 0) AS empty_seats
    FROM airlines_detail ad
    LEFT JOIN bookings b ON ad.airplane_id = b.airplane_id
),
airline_avg AS (
    -- Calculate average empty seats per airline using GROUP BY
    SELECT
        airline_id,
        AVG(empty_seats) AS avg_empty_seats
    FROM empty_seats
    GROUP BY airline_id
),
min_diff AS (
    -- Find the minimum absolute difference from average per airline
    SELECT
        es.airline_id,
        MIN(ABS(es.empty_seats - aa.avg_empty_seats)) AS min_abs_diff
    FROM empty_seats es
    JOIN airline_avg aa ON es.airline_id = aa.airline_id
    GROUP BY es.airline_id
),
closest AS (
    -- Get airplanes whose empty seats are closest to the average
    SELECT
        es.airplane_id,
        es.airline_id,
        es.empty_seats,
        aa.avg_empty_seats
    FROM empty_seats es
    JOIN airline_avg aa ON es.airline_id = aa.airline_id
    JOIN min_diff md ON es.airline_id = md.airline_id
    WHERE ABS(es.empty_seats - aa.avg_empty_seats) = md.min_abs_diff
)
SELECT
    airline_id,
    STRING_AGG(airplane_id::TEXT, ',' ORDER BY airplane_id) AS airplane_ids,
    empty_seats,
    ROUND(avg_empty_seats, 2) AS avg_empty_seats
FROM closest
GROUP BY airline_id, empty_seats, avg_empty_seats
ORDER BY airline_id;
