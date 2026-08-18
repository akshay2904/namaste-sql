-- ======================================================================
-- 128 - Train Schedule
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Fractal analytics
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/128-train-schedule
-- ======================================================================

/*
You are given a table of  train schedule which contains the arrival and departure times of trains at each station on a given day. 
At each station one platform can accommodate only one train at a time, from the beginning of the minute the train arrives until the end of the minute it departs. 
Write a query to find the minimum number of platforms required at each station to handle all train traffic to ensure that no two trains overlap at any station.

 
Table: train_schedule 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| station_id    | int      |
| train_id      | int      |
| arrival_time  | time     |
| departure_time| time     |
+-------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH events AS (
    -- Create +1 event for each arrival and -1 event for each departure
    -- Arrivals happen at the START of the minute, departures at END of the minute
    -- So at the same time, process arrivals before departures (arrival has priority = 1, departure = 2)
    SELECT station_id, arrival_time  AS event_time, 1  AS event_type  FROM train_schedule
    UNION ALL
    SELECT station_id, departure_time AS event_time, -1 AS event_type FROM train_schedule
),
running_count AS (
    SELECT
        station_id,
        event_time,
        event_type,
        -- Running sum ordered by time; for ties, arrivals (+1) come before departures (-1)
        -- so we sort event_type DESC (1 before -1)
        SUM(event_type) OVER (
            PARTITION BY station_id
            ORDER BY event_time, event_type DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS platforms_in_use
    FROM events
)
SELECT
    station_id,
    MAX(platforms_in_use) AS min_platforms_required
FROM running_count
GROUP BY station_id
ORDER BY station_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- For each train at each station, count how many other trains overlap with it.
-- Two trains overlap if one arrives before or when the other departs AND vice versa.
-- (train A arrival <= train B departure) AND (train B arrival <= train A departure)
-- The max overlap count + 1 gives the platforms needed at that moment.

SELECT
    station_id,
    MAX(overlapping_trains) AS min_platforms_required
FROM (
    SELECT
        t1.station_id,
        t1.train_id,
        -- Count all trains (including itself) that are present at the same time as t1
        COUNT(t2.train_id) AS overlapping_trains
    FROM train_schedule t1
    JOIN train_schedule t2
        ON t1.station_id = t2.station_id
       -- t2 is still present when t1 arrives (t2 arrived before t1 departs AND t2 departs after t1 arrives)
       AND t1.arrival_time  <= t2.departure_time
       AND t2.arrival_time  <= t1.departure_time
    GROUP BY
        t1.station_id,
        t1.train_id
) AS overlap_counts
GROUP BY station_id
ORDER BY station_id;
