-- ======================================================================
-- 152 - Active Viewers by Day
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Atlassian
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/152-active-viewers-by-day
-- ======================================================================

/*
In a content platform, users (viewers) can read various articles, and each article may be written by one or more authors (co-authors). The platform tracks which articles a viewer reads on each date, and also maintains information about which authors contributed to which articles.

You are tasked with identifying the dates on which a viewer read multiple different articles, and those articles were authored by more than one distinct author. Note that an article can be co-authored by multiple authors.

Return all (viewer_id, view_date) pairs where the viewer read **more than one unique article** on the same date, and those articles were written by **at least two different authors**. Sort the result by both columns respectively. 

 
Table: articles
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| article_id   | INT      |
| author_id    | INT      | 
+-------------------------+Table: views
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| viewer_id    | INT      | 
| view_date    | date     |
| article_id   | INT      | 
+-------------------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH article_authors AS (
    -- Get distinct article-author pairs to avoid duplicate counting
    SELECT DISTINCT article_id, author_id
    FROM articles
),
viewer_article_stats AS (
    SELECT
        v.viewer_id,
        v.view_date,
        COUNT(DISTINCT v.article_id)   AS unique_articles,
        COUNT(DISTINCT aa.author_id)   AS unique_authors
    FROM views v
    JOIN article_authors aa
        ON v.article_id = aa.article_id
    GROUP BY v.viewer_id, v.view_date
)
SELECT viewer_id, view_date
FROM viewer_article_stats
WHERE unique_articles > 1
  AND unique_authors  > 1
ORDER BY viewer_id, view_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    v.viewer_id,
    v.view_date
FROM views v
JOIN (
    -- Distinct article-author pairs
    SELECT DISTINCT article_id, author_id
    FROM articles
) aa
    ON v.article_id = aa.article_id
GROUP BY v.viewer_id, v.view_date
HAVING COUNT(DISTINCT v.article_id) > 1   -- more than one unique article read
   AND COUNT(DISTINCT aa.author_id)  > 1  -- written by at least two different authors
ORDER BY v.viewer_id, v.view_date;
