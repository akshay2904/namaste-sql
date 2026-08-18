-- ======================================================================
-- 37 - Spotify Popular Tracks
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Spotify
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/37-spotify-popular-tracks
-- ======================================================================

/*
Suppose you are a data analyst working for Spotify (a music streaming service company) . Your company is interested in analyzing user engagement with playlists and wants to identify the most popular tracks among all the playlists.

Write an SQL query to find the top 2 most popular tracks based on number of playlists they are part of. 

Your query should return the top 2 track ID along with total number of playlist they are part of , sorted by the same and  track id in descending order , Please consider only those playlists which were played by at least 2 distinct users.

 
Table: playlists
+---------------+--------------+
| COLUMN_NAME   | DATA_TYPE    |
+---------------+--------------+
| playlist_id   | int          |
| playlist_name | varchar(15) |
+---------------+--------------+Table: playlist_tracks
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| playlist_id | int       |
| track_id    | int       |
+-------------+-----------+Table: playlist_plays
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| playlist_id | int        |
| user_id     | varchar(2) |
+-------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH valid_playlists AS (
    -- Playlists played by at least 2 distinct users
    SELECT playlist_id
    FROM playlist_plays
    GROUP BY playlist_id
    HAVING COUNT(DISTINCT user_id) >= 2
),
track_popularity AS (
    -- Count distinct valid playlists per track
    SELECT 
        pt.track_id,
        COUNT(pt.playlist_id) AS total_playlists,
        RANK() OVER (ORDER BY COUNT(pt.playlist_id) DESC, pt.track_id DESC) AS rnk
    FROM playlist_tracks pt
    INNER JOIN valid_playlists vp ON pt.playlist_id = vp.playlist_id
    GROUP BY pt.track_id
)
SELECT 
    track_id,
    total_playlists
FROM track_popularity
WHERE rnk <= 2
ORDER BY total_playlists DESC, track_id DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    pt.track_id,
    COUNT(pt.playlist_id) AS total_playlists
FROM playlist_tracks pt
WHERE pt.playlist_id IN (
    -- Filter playlists played by at least 2 distinct users
    SELECT playlist_id
    FROM playlist_plays
    GROUP BY playlist_id
    HAVING COUNT(DISTINCT user_id) >= 2
)
GROUP BY pt.track_id
ORDER BY total_playlists DESC, pt.track_id DESC
LIMIT 2;
