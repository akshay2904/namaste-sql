-- ======================================================================
-- 135 - Music Lovers
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Spotify
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/135-music-lovers
-- ======================================================================

/*
At Spotify, we track user activity to understand their engagement with the platform. One of the key metrics we focus on is how consistently a user listens to music each day. A user is considered "consistent" if they have login session every single day since their first login.

Your task is to identify users who have logged in and listened to music every single day since their first login date until today.

Note: Dates are as per UTC time zone.

 

Table: user_sessions
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| user_id         | int      |
| login_timestamp | datetime | 
+-----------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_activity AS (
    -- Get distinct login dates per user
    SELECT
        user_id,
        DATE(login_timestamp AT TIME ZONE 'UTC') AS login_date
    FROM user_sessions
    GROUP BY user_id, DATE(login_timestamp AT TIME ZONE 'UTC')
),
user_stats AS (
    SELECT
        user_id,
        MIN(login_date)                          AS first_login,
        CURRENT_DATE AT TIME ZONE 'UTC'          AS today,
        COUNT(DISTINCT login_date)               AS days_active,
        -- Expected number of consecutive days from first login to today
        (CURRENT_DATE - MIN(login_date)) + 1     AS days_expected
    FROM daily_activity
    GROUP BY user_id
)
SELECT user_id
FROM user_stats
WHERE days_active = days_expected;  -- Every single day is covered


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT user_id
FROM (
    SELECT
        user_id,
        -- Count of distinct days the user was active
        COUNT(DISTINCT DATE(login_timestamp AT TIME ZONE 'UTC')) AS days_active
    FROM user_sessions
    GROUP BY user_id
) AS active_days
WHERE days_active = (
    SELECT
        -- Total days from this user's first login until today (inclusive)
        (CURRENT_DATE - MIN(DATE(login_timestamp AT TIME ZONE 'UTC'))) + 1
    FROM user_sessions AS sub
    WHERE sub.user_id = active_days.user_id  -- correlated subquery per user
);
