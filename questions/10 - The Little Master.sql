-- ======================================================================
-- 10 - The Little Master
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/10-the-little-master
-- ======================================================================

/*
Sachin Tendulkar - Also known as little master. You are given runs scored by Sachin in his first 10 matches. You need to write an SQL to get match number when he completed 500 runs and his batting average at the end of 10 matches.

Batting Average = (Total runs scored) / (no of times batsman got out)

Round the result to 2 decimal places.

 
Table: sachin
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| match_no    | int         |
| runs_scored | int         |
| status      | varchar(10) |
+-------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
  (SELECT match_no 
   FROM sachin 
   WHERE SUM(runs_scored) OVER (ORDER BY match_no) >= 500 
   LIMIT 1) AS match_completed_500_runs,
  ROUND(
    (SELECT SUM(runs_scored) FROM sachin) / 
    (SELECT COUNT(*) FROM sachin WHERE status = 'out'),
    2
  ) AS batting_average_10_matches
FROM sachin
LIMIT 1;
```

Alternatively, a more readable version:

```sql
WITH cumulative_runs AS (
  SELECT 
    match_no,
    SUM(runs_scored) OVER (ORDER BY match_no) AS total_runs
  FROM sachin
),
match_500 AS (
  SELECT MIN(match_no) AS match_completed_500
  FROM cumulative_runs
  WHERE total_runs >= 500
),
stats AS (
  SELECT 
    ROUND(
      SUM(runs_scored)::NUMERIC / NULLIF(COUNT(CASE WHEN status = 'out' THEN 1 END), 0),
      2
    ) AS batting_avg
  FROM sachin
)
SELECT 
  m.match_completed_500 AS match_completed_500_runs,
  s.batting_avg AS batting_average_10_matches
FROM match_500 m
CROSS JOIN stats s;
```
