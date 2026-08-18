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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_trips AS (
    -- Assign row numbers per driver ordered by trip_time
    SELECT
        driver_id,
        trip_id,
        trip_time,
        rating,
        ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY trip_time, trip_id) AS rn,
        CASE WHEN rating >= 4 THEN 1 ELSE 0 END AS is_positive
    FROM rating_table
),
grouped AS (
    -- Classic "islands" technique: subtract row number from a positive-only row number
    -- to get a constant group identifier for consecutive positive streaks
    SELECT
        driver_id,
        is_positive,
        rn,
        -- Row number only among positive trips per driver
        rn - ROW_NUMBER() OVER (PARTITION BY driver_id, is_positive ORDER BY rn) AS grp
    FROM ranked_trips
),
streak_lengths AS (
    -- Count how many consecutive positive trips form each streak
    SELECT
        driver_id,
        COUNT(*) AS streak_len
    FROM grouped
    WHERE is_positive = 1
    GROUP BY driver_id, grp
),
max_streaks AS (
    -- Get max streak per driver; streak value = count - 1 (as per problem definition)
    SELECT
        driver_id,
        MAX(streak_len) - 1 AS max_streak
    FROM streak_lengths
    GROUP BY driver_id
)
SELECT
    driver_id,
    max_streak
FROM max_streaks
WHERE max_streak >= 1  -- at least 1 streak means at least 2 consecutive positive trips
ORDER BY max_streak DESC, driver_id DESC;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH ordered_trips AS (
    -- Number trips per driver sequentially by time
    SELECT
        driver_id,
        trip_id,
        trip_time,
        rating,
        (
            SELECT COUNT(*)
            FROM rating_table r2
            WHERE r2.driver_id = r1.driver_id
              AND (r2.trip_time < r1.trip_time
                   OR (r2.trip_time = r1.trip_time AND r2.trip_id <= r1.trip_id))
        ) AS rn,
        CASE WHEN rating >= 4 THEN 1 ELSE 0 END AS is_positive
    FROM rating_table r1
),
island_groups AS (
    -- For each positive trip, compute group key = rn minus count of positive trips up to this point
    SELECT
        o1.driver_id,
        o1.rn,
        o1.is_positive,
        o1.rn - (
            SELECT COUNT(*)
            FROM ordered_trips o2
            WHERE o2.driver_id = o1.driver_id
              AND o2.is_positive = 1
              AND o2.rn <= o1.rn
        ) AS grp
    FROM ordered_trips o1
    WHERE o1.is_positive = 1
),
streak_counts AS (
    -- Count trips per streak group per driver
    SELECT
        driver_id,
        grp,
        COUNT(*) AS streak_len
    FROM island_groups
    GROUP BY driver_id, grp
),
max_streaks AS (
    -- Maximum streak length per driver, convert to streak value (count - 1)
    SELECT
        driver_id,
        MAX(streak_len) - 1 AS max_streak
    FROM streak_counts
    GROUP BY driver_id
)
SELECT
    driver_id,
    max_streak
FROM max_streaks
WHERE max_streak >= 1
ORDER BY max_streak DESC, driver_id DESC;
