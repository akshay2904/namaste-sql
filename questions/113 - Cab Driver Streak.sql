-- ======================================================================
-- 113 - Cab Driver Streak
-- ======================================================================
-- Difficulty : Extreme Hard
-- Category   : Analytics
-- Companies  : Lyft
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/113-cab-driver-streak
-- ======================================================================

/*
A Cab booking company has a dataset of its trip ratings, each row represents a single trip of a driver. A trip has a positive rating if it was rated 4 or above, a streak of positive ratings is when a driver has a rating of 4 and above in consecutive trips. example: If there are 3 consecutive trips with a rating of 4 or above then the streak is 2.
Find out the maximum streak that a driver has had and sort the output in descending order of their maximum streak and then by descending order of driver_id.
Note: only users who have at least 1 streak should be included in the output.
 
Table: rating_table 
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| trip_time       | datetime |    
| driver_id       | varchar  |
| trip_id         | int      |
| rating          | int      |
+-----------------+----------+
*/


-- Write your SQL solution below:

```sql
WITH rated_trips AS (
  SELECT 
    driver_id,
    trip_id,
    trip_time,
    rating,
    -- Identify if trip is positive (rating >= 4)
    CASE WHEN rating >= 4 THEN 1 ELSE 0 END as is_positive,
    -- Create groups: increment group number when streak breaks
    SUM(CASE WHEN rating >= 4 THEN 0 ELSE 1 END) 
      OVER (PARTITION BY driver_id ORDER BY trip_time, trip_id) as streak_group
  FROM rating_table
),
streak_lengths AS (
  SELECT 
    driver_id,
    streak_group,
    COUNT(*) - 1 as streak_length
  FROM rated_trips
  WHERE is_positive = 1
  GROUP BY driver_id, streak_group
),
max_streaks AS (
  SELECT 
    driver_id,
    MAX(streak_length) as max_streak
  FROM streak_lengths
  GROUP BY driver_id
  HAVING MAX(streak_length) >= 1
)
SELECT 
  driver_id,
  max_streak
FROM max_streaks
ORDER BY max_streak DESC, driver_id DESC;
```
