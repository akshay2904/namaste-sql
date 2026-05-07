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

```sql
SELECT DISTINCT v.viewer_id, v.view_date
FROM views v
WHERE (v.viewer_id, v.view_date) IN (
  -- Find viewer_id and view_date combinations where viewer read multiple articles
  SELECT v2.viewer_id, v2.view_date
  FROM views v2
  GROUP BY v2.viewer_id, v2.view_date
  HAVING COUNT(DISTINCT v2.article_id) > 1
)
AND (v.viewer_id, v.view_date) IN (
  -- Find viewer_id and view_date combinations where those articles have at least 2 distinct authors
  SELECT v3.viewer_id, v3.view_date
  FROM views v3
  JOIN articles a ON v3.article_id = a.article_id
  GROUP BY v3.viewer_id, v3.view_date
  HAVING COUNT(DISTINCT a.author_id) >= 2
)
ORDER BY v.viewer_id, v.view_date;
```
