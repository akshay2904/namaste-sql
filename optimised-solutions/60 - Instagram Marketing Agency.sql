-- ======================================================================
-- 60 - Instagram Marketing Agency
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Meta
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/60-instagram-marketing-agency
-- ======================================================================

/*
You are working for a marketing agency that manages multiple Instagram influencer accounts. Your task is to analyze the engagement performance of these influencers before and after they join your company.
Write an SQL query to calculate average engagement growth rate percent for each influencer after they joined your company compare to before. Round the growth rate to 2 decimal places and sort the output in decreasing order of growth rate.
Engagement = (# of likes + # of comments on each post)
 
Table: influencers
+---------------+-------------+
| COLUMN_NAME   | DATA_TYPE   |
+---------------+-------------+
| influencer_id | int         |
| join_date     | date        |
| username      | varchar(10) |
+---------------+-------------+Table: posts
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| comments      | int       |
| influencer_id | int       |
| likes         | int       |
| post_date     | date      |
| post_id       | int       |
+---------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH post_engagement AS (
    -- Calculate engagement per post and flag pre/post join in one pass
    SELECT
        p.influencer_id,
        p.likes + p.comments AS engagement,
        CASE WHEN p.post_date >= i.join_date THEN 'after' ELSE 'before' END AS period
    FROM posts p
    JOIN influencers i ON p.influencer_id = i.influencer_id
),
avg_engagement AS (
    -- Average engagement per influencer per period
    SELECT
        influencer_id,
        AVG(engagement) FILTER (WHERE period = 'after')  AS avg_after,
        AVG(engagement) FILTER (WHERE period = 'before') AS avg_before
    FROM post_engagement
    GROUP BY influencer_id
)
SELECT
    i.username,
    ROUND(
        (avg_after - avg_before) / NULLIF(avg_before, 0) * 100.0,
        2
    ) AS growth_rate_pct
FROM avg_engagement a
JOIN influencers i ON a.influencer_id = i.influencer_id
WHERE avg_before IS NOT NULL  -- exclude influencers with no pre-join posts
  AND avg_after  IS NOT NULL  -- exclude influencers with no post-join posts
ORDER BY growth_rate_pct DESC;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    i.username,
    ROUND(
        (after_stats.avg_after - before_stats.avg_before)
        / NULLIF(before_stats.avg_before, 0) * 100.0,
        2
    ) AS growth_rate_pct
FROM influencers i
-- Average engagement BEFORE joining
JOIN (
    SELECT
        p.influencer_id,
        AVG(p.likes + p.comments) AS avg_before
    FROM posts p
    JOIN influencers inf ON p.influencer_id = inf.influencer_id
    WHERE p.post_date < inf.join_date
    GROUP BY p.influencer_id
) AS before_stats ON i.influencer_id = before_stats.influencer_id
-- Average engagement AFTER joining
JOIN (
    SELECT
        p.influencer_id,
        AVG(p.likes + p.comments) AS avg_after
    FROM posts p
    JOIN influencers inf ON p.influencer_id = inf.influencer_id
    WHERE p.post_date >= inf.join_date
    GROUP BY p.influencer_id
) AS after_stats ON i.influencer_id = after_stats.influencer_id
ORDER BY growth_rate_pct DESC;
