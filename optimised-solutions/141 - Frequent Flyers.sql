-- ======================================================================
-- 141 - Frequent Flyers
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Agoda
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/141-frequent-flyers
-- ======================================================================

/*
Identify passengers with more than 5 flights from the same airport since last 1 year from current date. Display passenger id, departure airport code and number of flights.

 

Table: passenger_flights
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| Passenger_id  | VARCHAR  |
| Flight_id     | VARCHAR  | 
| Departure_date| date     | 
+---------------+----------+Table: flight_details
+-------------------------+-----------+
| COLUMN_NAME             | DATA_TYPE |
+-------------------------+-----------+
| Flight_id               | VARCHAR   |
| Departure_airport_code  | VARCHAR   |
| Arrival_airport         | DATE      |
+-------------------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH flight_counts AS (
    SELECT 
        pf.Passenger_id,
        fd.Departure_airport_code,
        COUNT(*) AS num_flights,
        -- Using window function to rank passengers by flight count per airport
        RANK() OVER (PARTITION BY pf.Passenger_id ORDER BY COUNT(*) DESC) AS rnk
    FROM passenger_flights pf
    INNER JOIN flight_details fd 
        ON pf.Flight_id = fd.Flight_id
    WHERE pf.Departure_date >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY 
        pf.Passenger_id,
        fd.Departure_airport_code
)
SELECT 
    Passenger_id,
    Departure_airport_code,
    num_flights
FROM flight_counts
WHERE num_flights > 5
ORDER BY 
    Passenger_id,
    num_flights DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    pf.Passenger_id,
    fd.Departure_airport_code,
    COUNT(*) AS num_flights
FROM passenger_flights pf
INNER JOIN flight_details fd 
    ON pf.Flight_id = fd.Flight_id
WHERE 
    -- Filter flights within the last 1 year from current date
    pf.Departure_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY 
    pf.Passenger_id,
    fd.Departure_airport_code
HAVING 
    COUNT(*) > 5
ORDER BY 
    pf.Passenger_id,
    num_flights DESC;
