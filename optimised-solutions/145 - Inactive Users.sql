-- ======================================================================
-- 145 - Inactive Users
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Linkedin
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/145-inactive-users-927cf069
-- ======================================================================

/*
You’re given two tables: users and events. The users table contains information about users, including the social media platform they belong to (platform column with values ‘LinkedIn’, ‘Meta’, or ‘Instagram’). The events table stores user interactions in the action column, which can be ‘like’, ‘comment’, or ‘post’. Please note that one user can belong to multiple social media platforms.

Write a query to calculate the percentage of users on each social media platform who have never liked or commented, rounded to two decimal places. Order the result by platform.

 
Table: users
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| user_id     | INTEGER  |
| name        | VARCHAR  | 
| platform    | VARCHAR  | 
+-------------+----------+Table: events
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| event_id    | INTEGER  |
| user_id     | INTEGER  |
| action      | VARCHAR  | 
| platform    | VARCHAR  | 
| created_at  | DATETIME | 
+-------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH platform_users AS (
    SELECT
        platform,
        COUNT(DISTINCT user_id) AS total_users
    FROM users
    GROUP BY platform
),
active_users AS (
    -- Users who have liked or commented on each platform
    SELECT DISTINCT
        u.platform,
        u.user_id
    FROM users u
    INNER JOIN events e
        ON u.user_id = e.user_id
        AND e.action IN ('like', 'comment')
),
inactive_counts AS (
    SELECT
        pu.platform,
        pu.total_users,
        COUNT(DISTINCT au.user_id) AS active_users
    FROM platform_users pu
    LEFT JOIN active_users au
        ON pu.platform = au.platform
    GROUP BY pu.platform, pu.total_users
)
SELECT
    platform,
    ROUND(
        (total_users - COALESCE(active_users, 0)) * 100.0 / total_users,
        2
    ) AS percentage_never_liked_or_commented
FROM inactive_counts
ORDER BY platform;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    u.platform,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN u.user_id NOT IN (
                SELECT e.user_id
                FROM events e
                WHERE e.action IN ('like', 'comment')
            )
            THEN u.user_id
        END) * 100.0 / COUNT(DISTINCT u.user_id),
        2
    ) AS percentage_never_liked_or_commented
FROM users u
GROUP BY u.platform
ORDER BY u.platform;
