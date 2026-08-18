-- ======================================================================
-- 88 - Netflix Device Type (PART-1)
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Netflix
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/88-netflix-device-type-part-1
-- ======================================================================

/*
In the Netflix dataset containing information about viewers and their viewing history, devise a query to identify viewers who primarily use mobile devices for viewing, but occasionally switch to other devices. Specifically, find viewers who have watched at least 75% of their total viewing time on mobile devices but have also used at least one other devices such as tablets or smart TVs for viewing. Provide the user ID and the percentage of viewing time spent on mobile devices. Round the result to nearest integer.

 
Table: viewing_history
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| user_id     | int          |
| title       | varchar(20)  |
| device_type | varchar(10)  |
| watch_mins  | int          |
+-------------+--------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH device_stats AS (
    SELECT
        user_id,
        device_type,
        SUM(watch_mins) AS device_mins,
        SUM(SUM(watch_mins)) OVER (PARTITION BY user_id) AS total_mins,
        COUNT(DISTINCT device_type) OVER (PARTITION BY user_id) AS distinct_devices
    FROM viewing_history
    GROUP BY user_id, device_type
)
SELECT
    user_id,
    ROUND(device_mins * 100.0 / total_mins) AS mobile_percentage
FROM device_stats
WHERE
    device_type = 'mobile'
    AND ROUND(device_mins * 100.0 / total_mins) >= 75
    AND distinct_devices > 1  -- has used at least one other device
ORDER BY mobile_percentage DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    m.user_id,
    ROUND(m.mobile_mins * 100.0 / t.total_mins) AS mobile_percentage
FROM
    -- Total watch time per user
    (SELECT user_id, SUM(watch_mins) AS total_mins
     FROM viewing_history
     GROUP BY user_id) t
    INNER JOIN
    -- Mobile watch time per user
    (SELECT user_id, SUM(watch_mins) AS mobile_mins
     FROM viewing_history
     WHERE device_type = 'mobile'
     GROUP BY user_id) m
    ON t.user_id = m.user_id
WHERE
    -- At least 75% on mobile
    ROUND(m.mobile_mins * 100.0 / t.total_mins) >= 75
    -- Has used at least one non-mobile device
    AND t.user_id IN (
        SELECT DISTINCT user_id
        FROM viewing_history
        WHERE device_type <> 'mobile'
    )
ORDER BY mobile_percentage DESC;
