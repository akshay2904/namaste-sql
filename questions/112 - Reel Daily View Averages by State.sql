-- ======================================================================
-- 112 - Reel Daily View Averages by State
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Meta
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/112-reel-daily-view-averages-by-state
-- ======================================================================

/*
Meta (formerly Facebook) is analyzing the performance of Instagram Reels across different states in the USA. You have access to a table named REEL that tracks the cumulative views of each reel over time. Write an SQL to get average daily views for each Instagram Reel in each state. Round the average to 2 decimal places and sort the result by average is descending order. 

 
Table: reel 
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| reel_id         | int      |    
| record_date     | date     |
| state           | varchar  |
| cumulative_views| int      |
+-------------+--------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    reel_id,
    state,
    ROUND(AVG(cumulative_views), 2) AS avg_daily_views
FROM reel
GROUP BY reel_id, state
ORDER BY avg_daily_views DESC;
```
