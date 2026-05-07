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

```sql
WITH time_events AS (
  -- Create arrival events (train needs platform at arrival)
  SELECT 
    station_id,
    arrival_time AS event_time,
    1 AS platform_change
  FROM train_schedule
  
  UNION ALL
  
  -- Create departure events (train releases platform after departure)
  -- Process departures after arrivals at same time to handle edge cases
  SELECT 
    station_id,
    departure_time AS event_time,
    -1 AS platform_change
  FROM train_schedule
),
sorted_events AS (
  SELECT 
    station_id,
    event_time,
    platform_change,
    SUM(platform_change) OVER (
      PARTITION BY station_id 
      ORDER BY event_time, platform_change DESC
    ) AS platforms_in_use
  FROM time_events
)
SELECT 
  station_id,
  MAX(platforms_in_use) AS min_platforms_required
FROM sorted_events
GROUP BY station_id
ORDER BY station_id;
```

The solution works as follows:

1. **time_events CTE**: Convert each train's arrival and departure into two separate events:
   - Arrival event: +1 platform needed
   - Departure event: -1 platform released
   
2. **sorted_events CTE**: 
   - Sort events by time at each station
   - Use `ORDER BY event_time, platform_change DESC` to ensure departures (-1) are processed before arrivals (+1) when they occur at the same time
   - Calculate running sum of platform changes to track concurrent platform usage

3. **Final SELECT**: 
   - Find the maximum platforms in use across all time points for each station
   - This maximum represents the minimum platforms needed to handle all trains without overlap
