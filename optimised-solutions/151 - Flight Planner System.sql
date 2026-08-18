-- ======================================================================
-- 151 - Flight Planner System
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Microsoft
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/151-flight-planner-system
-- ======================================================================

/*
You are building a flight planner system for a travel application. The system stores data about flights between airports and users who want to travel between cities. The planner must help each user find the fastest possible flight route from their source city to their destination city.

 

Each route may consist of:
A direct flight, or
A two-leg journey with only one stopover at an intermediate city.

A stopover is allowed only if the connecting flight departs at or after the arrival time of the first flight. The second flight must depart from the airport where the first one landed.

 

Write a SQL query that returns following columns, for each user:

user_id
trip_start_city
middle_city (NULL if it's a direct flight)
trip_end_city

trip_time (Total journey duration in minutes)
flight_ids (semicolon-separated , eg: 1 for direct, or 3;5 for one-stop)

 

Return all possible valid routes, sorted by user_id and shortest duration.

 
Table: users
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| user_id         | INT      |
| source_city     | VARCHAR  |  
| destination_city| VARCHAR  |  
+--------------+-------------+
Table: airports
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| port_code    | VARCHAR  |
| city_name    | VARCHAR  | 
+-------------------------+
Table: flights
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| flight_id    | VARCHAR  |
| start_port   | VARCHAR  | 
| end_port     | VARCHAR  | 
| start_time   | datetime | 
| end_time     | datetime | 
+-------------------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH direct_flights AS (
    -- Find all direct flights between city pairs
    SELECT
        f.flight_id,
        a1.city_name AS from_city,
        a2.city_name AS to_city,
        f.start_time,
        f.end_time,
        EXTRACT(EPOCH FROM (f.end_time - f.start_time)) / 60 AS duration_min
    FROM flights f
    JOIN airports a1 ON f.start_port = a1.port_code
    JOIN airports a2 ON f.end_port   = a2.port_code
),
one_stop_flights AS (
    -- Find all valid two-leg journeys with exactly one stopover
    SELECT
        f1.flight_id        AS flight1_id,
        f2.flight_id        AS flight2_id,
        f1.from_city        AS from_city,
        f1.to_city          AS middle_city,
        f2.to_city          AS to_city,
        f1.start_time,
        f2.end_time,
        -- Total elapsed time from first departure to last arrival
        EXTRACT(EPOCH FROM (f2.end_time - f1.start_time)) / 60 AS duration_min
    FROM direct_flights f1
    JOIN direct_flights f2
        ON f1.to_city = f2.from_city          -- connecting city matches
        AND f2.start_time >= f1.end_time       -- connection is valid (no time travel)
        AND f1.from_city <> f2.to_city         -- avoid trivial loops back to origin
),
user_routes AS (
    -- Direct routes for each user
    SELECT
        u.user_id,
        u.source_city      AS trip_start_city,
        NULL::VARCHAR      AS middle_city,
        u.destination_city AS trip_end_city,
        d.duration_min     AS trip_time,
        d.flight_id::TEXT  AS flight_ids
    FROM users u
    JOIN direct_flights d
        ON d.from_city = u.source_city
        AND d.to_city  = u.destination_city

    UNION ALL

    -- One-stop routes for each user
    SELECT
        u.user_id,
        u.source_city      AS trip_start_city,
        o.middle_city,
        u.destination_city AS trip_end_city,
        o.duration_min     AS trip_time,
        (o.flight1_id || ';' || o.flight2_id) AS flight_ids
    FROM users u
    JOIN one_stop_flights o
        ON o.from_city = u.source_city
        AND o.to_city  = u.destination_city
)
SELECT
    user_id,
    trip_start_city,
    middle_city,
    trip_end_city,
    trip_time,
    flight_ids
FROM user_routes
ORDER BY user_id, trip_time;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    u.user_id,
    u.source_city                              AS trip_start_city,
    NULL::VARCHAR                              AS middle_city,
    u.destination_city                         AS trip_end_city,
    -- Duration in minutes for direct flight
    EXTRACT(EPOCH FROM (f.end_time - f.start_time)) / 60 AS trip_time,
    f.flight_id::TEXT                          AS flight_ids
FROM users u
JOIN flights f
    ON f.start_port = (
        SELECT port_code FROM airports WHERE city_name = u.source_city LIMIT 1
    )
    AND f.end_port = (
        SELECT port_code FROM airports WHERE city_name = u.destination_city LIMIT 1
    )

UNION ALL

SELECT
    u.user_id,
    u.source_city                              AS trip_start_city,
    a_mid.city_name                            AS middle_city,
    u.destination_city                         AS trip_end_city,
    -- Total elapsed time from first departure to second arrival
    EXTRACT(EPOCH FROM (f2.end_time - f1.start_time)) / 60 AS trip_time,
    (f1.flight_id || ';' || f2.flight_id)      AS flight_ids
FROM users u
-- First leg: departs from user's source city
JOIN airports a_src  ON a_src.city_name  = u.source_city
JOIN airports a_dst  ON a_dst.city_name  = u.destination_city
JOIN flights  f1     ON f1.start_port    = a_src.port_code
-- Intermediate airport / city
JOIN airports a_mid  ON a_mid.port_code  = f1.end_port
-- Second leg: departs from intermediate city, arrives at destination
JOIN flights  f2     ON f2.start_port    = a_mid.port_code
                    AND f2.end_port      = a_dst.port_code
                    AND f2.start_time   >= f1.end_time   -- valid connection
-- Exclude routes where the stopover is already the destination
WHERE a_mid.city_name <> u.destination_city
  AND a_mid.city_name <> u.source_city       -- exclude trivial same-city hops

ORDER BY user_id, trip_time;
