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

```sql
WITH empty_seats AS (
  -- Calculate empty seats for each airplane
  SELECT 
    a.airplane_id,
    a.airline_id,
    a.total_seats - COALESCE(b.booked, 0) AS empty_seats
  FROM airlines_detail a
  LEFT JOIN bookings b ON a.airplane_id = b.airplane_id
),
airline_avg AS (
  -- Calculate average empty seats per airline
  SELECT 
    airline_id,
    AVG(empty_seats) AS avg_empty_seats
  FROM empty_seats
  GROUP BY airline_id
),
closest_airplanes AS (
  -- Find airplanes closest to average empty seats for each airline
  SELECT 
    e.airline_id,
    e.airplane_id,
    e.empty_seats,
    ABS(e.empty_seats - aa.avg_empty_seats) AS diff
  FROM empty_seats e
  JOIN airline_avg aa ON e.airline_id = aa.airline_id
),
ranked_airplanes AS (
  -- Rank airplanes by difference from average
  SELECT 
    airline_id,
    airplane_id,
    diff,
    ROW_NUMBER() OVER (PARTITION BY airline_id ORDER BY diff, airplane_id) AS rn
  FROM closest_airplanes
)
-- Get the airplane(s) closest to average for each airline
SELECT 
  airline_id,
  STRING_AGG(CAST(airplane_id AS VARCHAR), ',' ORDER BY airplane_id) AS airplane_ids
FROM ranked_airplanes
WHERE rn = 1
GROUP BY airline_id
ORDER BY airline_id;
```
