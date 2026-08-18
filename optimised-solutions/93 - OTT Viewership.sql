-- ======================================================================
-- 93 - OTT Viewership
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Netflix
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/93-ott-viewership
-- ======================================================================

/*
You have a table named ott_viewership. Write an SQL query to find the top 2 most-watched shows in each genre in the United States. Return the show name, genre, and total duration watched for each of the top 2 most-watched shows in each genre. sort the result by genre and total duration.

 
Tables: ott_viewership
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| viewer_id    | int         |
| show_id      | int         |
| show_name    | varchar(20) |
| genre        | varchar(10) |
| country      | varchar(15) |
| view_date    | date        |
| duration_min | int         |
+--------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH genre_totals AS (
    SELECT
        show_name,
        genre,
        SUM(duration_min) AS total_duration
    FROM ott_viewership
    WHERE country = 'United States'
    GROUP BY show_name, genre
),
ranked_shows AS (
    SELECT
        show_name,
        genre,
        total_duration,
        RANK() OVER (PARTITION BY genre ORDER BY total_duration DESC) AS rnk
    FROM genre_totals
)
SELECT
    show_name,
    genre,
    total_duration
FROM ranked_shows
WHERE rnk <= 2
ORDER BY genre, total_duration DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    g1.show_name,
    g1.genre,
    g1.total_duration
FROM (
    -- Aggregate total duration per show per genre in the US
    SELECT
        show_name,
        genre,
        SUM(duration_min) AS total_duration
    FROM ott_viewership
    WHERE country = 'United States'
    GROUP BY show_name, genre
) g1
WHERE (
    -- Count how many shows in the same genre have strictly higher total duration
    SELECT COUNT(*)
    FROM (
        SELECT
            show_name,
            genre,
            SUM(duration_min) AS total_duration
        FROM ott_viewership
        WHERE country = 'United States'
        GROUP BY show_name, genre
    ) g2
    WHERE g2.genre = g1.genre
      AND g2.total_duration > g1.total_duration
) < 2  -- fewer than 2 shows ranked above means this show is in top 2
ORDER BY genre, total_duration DESC;
