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

```sql
WITH flight_durations AS (
  -- Calculate duration in minutes for each flight
  SELECT 
    flight_id,
    start_port,
    end_port,
    start_time,
    end_time,
    EXTRACT(EPOCH FROM (end_time - start_time)) / 60 AS duration_minutes
  FROM flights
),
direct_flights AS (
  -- Find direct flights for each user
  SELECT 
    u.user_id,
    u.source_city AS trip_start_city,
    NULL::VARCHAR AS middle_city,
    u.destination_city AS trip_end_city,
    fd.duration_minutes AS trip_time,
    fd.flight_id AS flight_ids
  FROM users u
  JOIN airports a1 ON u.source_city = a1.city_name
  JOIN airports a2 ON u.destination_city = a2.city_name
  JOIN flight_durations fd ON a1.port_code = fd.start_port AND a2.port_code = fd.end_port
),
connecting_flights AS (
  -- Find two-leg routes with one stopover
  SELECT 
    u.user_id,
    u.source_city AS trip_start_city,
    a2.city_name AS middle_city,
    u.destination_city AS trip_end_city,
    (fd1.duration_minutes + fd2.duration_minutes) AS trip_time,
    CONCAT(fd1.flight_id, ';', fd2.flight_id) AS flight_ids
  FROM users u
  JOIN airports a1 ON u.source_city = a1.city_name
  JOIN airports a2 ON a2.port_code IS NOT NULL
  JOIN airports a3 ON u.destination_city = a3.city_name
  JOIN flight_durations fd1 ON a1.port_code = fd1.start_port AND a2.port_code = fd1.end_port
  JOIN flight_durations fd2 ON a2.port_code = fd2.start_port AND a3.port_code = fd2.end_port
  -- Ensure stopover is valid: second flight departs at or after first flight arrives
  WHERE fd2.start_time >= fd1.end_time
    -- Exclude routes that are just direct flights (source -> destination directly via intermediate)
    AND NOT (a1.port_code = fd2.start_port AND a3.port_code = fd2.end_port)
)
SELECT 
  user_id,
  trip_start_city,
  middle_city,
  trip_end_city,
  trip_time,
  flight_ids
FROM (
  SELECT * FROM direct_flights
  UNION ALL
  SELECT * FROM connecting_flights
)
ORDER BY user_id, trip_time;
```
