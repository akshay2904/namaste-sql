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

```sql
WITH ranked_shows AS (
  SELECT
    show_name,
    genre,
    SUM(duration_min) AS total_duration_watched,
    ROW_NUMBER() OVER (PARTITION BY genre ORDER BY SUM(duration_min) DESC) AS rank
  FROM ott_viewership
  WHERE country = 'United States'
  GROUP BY show_name, genre
)
SELECT
  show_name,
  genre,
  total_duration_watched
FROM ranked_shows
WHERE rank <= 2
ORDER BY genre, total_duration_watched DESC;
```
