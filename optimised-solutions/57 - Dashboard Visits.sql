-- ======================================================================
-- 57 - Dashboard Visits
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Microsoft
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/57-dashboard-visits
-- ======================================================================

/*
You're working as a data analyst for a popular website's dashboard analytics team. Your task is to analyze user visits to the dashboard and identify users who are highly engaged with the platform. The dashboard records user visits along with timestamps to provide insights into user activity patterns.
A user can visit the dashboard multiple times within a day. However, to be counted as separate visits, there should be a minimum gap of 60 minutes between consecutive visits. If the next visit occurs within 60 minutes of the previous one, it's considered part of the same visit.

 
Table: dashboard_visit
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| user_id     | varchar(10) |
| visit_time  | datetime    |
+-------------+-------------+
Write an SQL query to find total number of visits by each user along with number of distinct days user has visited the dashboard. While calculating the number of distinct days you have to consider a visit even if it is same as previous days visit.
So for example if there is a visit at 2024-01-12 23:30:00 and next visit at 2024-01-13 00:15:00 , The visit on 13th will not be considered as new visit because it is within 1 hour window of previous visit but number of days will be counted as 2 only, display the output in ascending order of user id.
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_visits AS (
    SELECT
        user_id,
        visit_time,
        -- Get the previous visit time for each user
        LAG(visit_time) OVER (PARTITION BY user_id ORDER BY visit_time) AS prev_visit_time
    FROM dashboard_visit
),
visit_flags AS (
    SELECT
        user_id,
        visit_time,
        -- Flag as new visit if no previous visit OR gap >= 60 minutes
        CASE
            WHEN prev_visit_time IS NULL
              OR EXTRACT(EPOCH FROM (visit_time - prev_visit_time)) / 60 >= 60
            THEN 1
            ELSE 0
        END AS is_new_visit
    FROM ranked_visits
),
visit_groups AS (
    SELECT
        user_id,
        visit_time,
        is_new_visit,
        -- Assign group number to each visit session
        SUM(is_new_visit) OVER (PARTITION BY user_id ORDER BY visit_time) AS visit_group
    FROM visit_flags
),
session_days AS (
    SELECT
        user_id,
        visit_group,
        is_new_visit,
        -- For each session group, collect all distinct calendar dates touched
        COUNT(DISTINCT DATE(visit_time)) AS days_in_session
    FROM visit_groups
    GROUP BY user_id, visit_group, is_new_visit
)
SELECT
    user_id,
    -- Total distinct visits (sessions) = sum of is_new_visit flags
    SUM(CASE WHEN is_new_visit = 1 THEN 1 ELSE 0 END) AS total_visits,
    -- Total distinct days across all sessions (even non-new visits count toward days)
    SUM(days_in_session) AS total_distinct_days
FROM session_days
GROUP BY user_id
ORDER BY user_id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Step 1: Get all visits with their previous visit time using a self-join
WITH prev_visits AS (
    SELECT
        v1.user_id,
        v1.visit_time,
        MAX(v2.visit_time) AS prev_visit_time
    FROM dashboard_visit v1
    LEFT JOIN dashboard_visit v2
        ON v1.user_id = v2.user_id
        AND v2.visit_time < v1.visit_time
    GROUP BY v1.user_id, v1.visit_time
),
-- Step 2: Flag each visit as new (1) or continuation (0)
flagged_visits AS (
    SELECT
        user_id,
        visit_time,
        CASE
            WHEN prev_visit_time IS NULL
              OR (EXTRACT(EPOCH FROM (visit_time - prev_visit_time)) / 60) >= 60
            THEN 1
            ELSE 0
        END AS is_new_visit
    FROM prev_visits
),
-- Step 3: Assign session group by counting cumulative new visits
-- Brute force: use correlated subquery to compute visit group number
session_groups AS (
    SELECT
        f1.user_id,
        f1.visit_time,
        f1.is_new_visit,
        -- Count how many new visits occurred at or before this timestamp for the user
        (
            SELECT COUNT(*)
            FROM flagged_visits f2
            WHERE f2.user_id = f1.user_id
              AND f2.visit_time <= f1.visit_time
              AND f2.is_new_visit = 1
        ) AS visit_group
    FROM flagged_visits f1
),
-- Step 4: For each session group, find distinct days
session_day_counts AS (
    SELECT
        user_id,
        visit_group,
        MAX(is_new_visit) AS is_new_visit,       -- 1 if this group is a real new visit
        COUNT(DISTINCT DATE(visit_time)) AS days_in_session
    FROM session_groups
    GROUP BY user_id, visit_group
)
SELECT
    user_id,
    SUM(is_new_visit)    AS total_visits,
    SUM(days_in_session) AS total_distinct_days
FROM session_day_counts
GROUP BY user_id
ORDER BY user_id ASC;
