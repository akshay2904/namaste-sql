-- ======================================================================
-- 124 - Top 3 Netflix Shows
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Netflix
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/124-top-3-netflix-shows
-- ======================================================================

/*
Netflix’s analytics team wants to identify the Top 3 most popular shows based on the viewing patterns of its users. The definition of "popular" is based on two factors:

Unique Watchers: The total number of distinct users who have watched a show.
Total Watch Duration: The cumulative time users have spent watching the show.

In the case of ties in the number of unique watchers, the total watch duration will serve as the tie-breaker.

Write an SQL query to determine the Top 3 shows based on the above criteria. The output should be sorted by show_id and should include: show_id , unique_watchers, total_duration.

 
Table: watch_history 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| user_id       | int      |
| show_id       | int      |
| watch_date    | int      |
| watch_duration| int      |
+--------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH show_stats AS (
    SELECT
        show_id,
        COUNT(DISTINCT user_id)  AS unique_watchers,
        SUM(watch_duration)      AS total_duration
    FROM watch_history
    GROUP BY show_id
),
ranked AS (
    SELECT
        show_id,
        unique_watchers,
        total_duration,
        -- Rank by unique_watchers desc, break ties by total_duration desc
        RANK() OVER (ORDER BY unique_watchers DESC, total_duration DESC) AS rnk
    FROM show_stats
)
SELECT
    show_id,
    unique_watchers,
    total_duration
FROM ranked
WHERE rnk <= 3
ORDER BY show_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    show_id,
    unique_watchers,
    total_duration
FROM (
    SELECT
        show_id,
        COUNT(DISTINCT user_id) AS unique_watchers,
        SUM(watch_duration)     AS total_duration
    FROM watch_history
    GROUP BY show_id
) AS show_stats
WHERE (
    -- Count how many shows rank strictly above this one
    SELECT COUNT(*)
    FROM (
        SELECT
            show_id,
            COUNT(DISTINCT user_id) AS unique_watchers,
            SUM(watch_duration)     AS total_duration
        FROM watch_history
        GROUP BY show_id
    ) AS other_stats
    WHERE
        other_stats.unique_watchers > show_stats.unique_watchers
        OR (
            other_stats.unique_watchers = show_stats.unique_watchers
            AND other_stats.total_duration > show_stats.total_duration
        )
) < 3   -- fewer than 3 shows rank above => this show is in top 3
ORDER BY show_id;
