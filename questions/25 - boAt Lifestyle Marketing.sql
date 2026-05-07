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

```sql
SELECT DISTINCT c.id, c.name
FROM creators c
INNER JOIN (
  -- Get creators with 100k+ followers on at least 2 platforms
  SELECT id
  FROM creators
  WHERE followers >= 100000
  GROUP BY id
  HAVING COUNT(DISTINCT platform) >= 2
) qualified_platforms ON c.id = qualified_platforms.id
INNER JOIN (
  -- Get creators with 50k+ views on their latest YouTube video
  SELECT creator_id
  FROM youtube_videos
  WHERE (creator_id, publish_date) IN (
    SELECT creator_id, MAX(publish_date)
    FROM youtube_videos
    GROUP BY creator_id
  )
  AND views >= 50000
) latest_videos ON c.id = latest_videos.creator_id
ORDER BY c.id;
```
