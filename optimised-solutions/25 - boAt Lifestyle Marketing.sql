-- ======================================================================
-- 25 - boAt Lifestyle Marketing
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Boat lifestyle
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/25-boat-lifestyle-marketing
-- ======================================================================

/*
boAt Lifestyle is focusing on influencer marketing to build and scale their brand. They want to partner with power creators for their upcoming campaigns. The creators should satisfy below conditions to qualify:

 
1- They should have 100k+ followers on at least 2 social media platforms and
2- They should have at least 50k+ views on their latest YouTube video.
Write an SQL to get creator id and name satisfying above conditions.

 
Table: creators
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| id          | int         |
| name        | varchar(10) |
| followers   | int         |
| platform    | varchar(10) |
+-------------+-------------+Table: youtube_videos
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| id           | int       |
| creator_id   | int       |
| publish_date | date      |
| views        | int       |
+--------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH platform_counts AS (
    -- Count platforms with 100k+ followers per creator
    SELECT 
        id,
        name,
        COUNT(*) FILTER (WHERE followers >= 100000) AS qualifying_platforms
    FROM creators
    GROUP BY id, name
),
latest_video AS (
    -- Get views of the latest YouTube video per creator using window function
    SELECT 
        creator_id,
        views,
        ROW_NUMBER() OVER (PARTITION BY creator_id ORDER BY publish_date DESC) AS rn
    FROM youtube_videos
)
SELECT 
    p.id,
    p.name
FROM platform_counts p
JOIN latest_video lv 
    ON p.id = lv.creator_id
    AND lv.rn = 1                     -- Only the latest video
WHERE p.qualifying_platforms >= 2     -- At least 2 platforms with 100k+ followers
  AND lv.views >= 50000;              -- Latest video has 50k+ views


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    c.id,
    c.name
FROM creators c
WHERE c.id IN (
    -- Condition 1: 100k+ followers on at least 2 platforms
    SELECT id
    FROM creators
    WHERE followers >= 100000
    GROUP BY id
    HAVING COUNT(*) >= 2
)
AND c.id IN (
    -- Condition 2: Latest YouTube video has 50k+ views
    SELECT creator_id
    FROM youtube_videos
    WHERE (creator_id, publish_date) IN (
        -- Get the most recent video date per creator
        SELECT creator_id, MAX(publish_date)
        FROM youtube_videos
        GROUP BY creator_id
    )
    AND views >= 50000
)
GROUP BY c.id, c.name;  -- Deduplicate in case creator appears on multiple rows
