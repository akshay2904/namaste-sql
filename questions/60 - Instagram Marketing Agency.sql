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

```sql
SELECT 
    i.influencer_id,
    i.username,
    ROUND(
        ((avg_engagement_after - avg_engagement_before) / avg_engagement_before) * 100,
        2
    ) AS growth_rate_percent
FROM (
    SELECT 
        i.influencer_id,
        i.username,
        i.join_date,
        AVG(CASE 
            WHEN p.post_date < i.join_date THEN p.likes + p.comments 
        END) AS avg_engagement_before,
        AVG(CASE 
            WHEN p.post_date >= i.join_date THEN p.likes + p.comments 
        END) AS avg_engagement_after
    FROM influencers i
    LEFT JOIN posts p ON i.influencer_id = p.influencer_id
    GROUP BY i.influencer_id, i.username, i.join_date
) AS engagement_data
WHERE avg_engagement_before IS NOT NULL 
    AND avg_engagement_after IS NOT NULL
    AND avg_engagement_before > 0
ORDER BY growth_rate_percent DESC;
```
