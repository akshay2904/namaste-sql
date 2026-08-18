-- ======================================================================
-- 3 - LinkedIn Top Voice
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Linkedin
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/3-linkedin-top-voice
-- ======================================================================

/*
LinkedIn is a professional social networking app. They want to give top voice badge to their best creators to encourage them to create more quality content. A creator qualifies for the badge if he/she satisfies following criteria.

 

1- Creator should have more than 50k followers.
2- Creator should have more than 100k impressions on the posts that they published in the month of Dec-2023.
3- Creator should have published atleast 3 posts in Dec-2023.

 

Write a SQL to get the list of top voice creators name along with no of posts and impressions by them in the month of Dec-2023.

 
Table: creators(primary key : creator_id)
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| creator_id   | int         |
| creator_name | varchar(20) |
| followers    | int         |
+--------------+-------------+Table: posts(primary key : post_id)
+--------------+------------+
| COLUMN_NAME  | DATA_TYPE  |
+--------------+------------+
| creator_id   | int        |
| post_id      | varchar(3) |
| publish_date | date       |
| impressions  | int        |
+--------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH dec_posts AS (
    -- Aggregate Dec-2023 post stats per creator in one scan
    SELECT
        creator_id,
        COUNT(post_id)      AS num_posts,
        SUM(impressions)    AS total_impressions
    FROM posts
    WHERE publish_date >= '2023-12-01'
      AND publish_date <  '2024-01-01'
    GROUP BY creator_id
    HAVING COUNT(post_id) >= 3          -- Criteria 3: at least 3 posts
       AND SUM(impressions) > 100000    -- Criteria 2: more than 100k impressions
)
SELECT
    c.creator_name,
    dp.num_posts,
    dp.total_impressions
FROM dec_posts dp
JOIN creators c
    ON c.creator_id = dp.creator_id
WHERE c.followers > 50000               -- Criteria 1: more than 50k followers
ORDER BY dp.total_impressions DESC;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    c.creator_name,
    p.num_posts,
    p.total_impressions
FROM creators c
JOIN (
    -- Subquery: aggregate Dec-2023 metrics per creator
    SELECT
        creator_id,
        COUNT(post_id)   AS num_posts,
        SUM(impressions) AS total_impressions
    FROM posts
    WHERE EXTRACT(YEAR  FROM publish_date) = 2023
      AND EXTRACT(MONTH FROM publish_date) = 12
    GROUP BY creator_id
) p ON p.creator_id = c.creator_id
WHERE c.followers > 50000               -- Criteria 1
  AND p.num_posts >= 3                  -- Criteria 3
  AND p.total_impressions > 100000      -- Criteria 2
ORDER BY p.total_impressions DESC;
