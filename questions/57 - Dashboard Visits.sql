-- ======================================================================
-- 57 - Dashboard Visits
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Microsoft
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/57-dashboard-visits
-- ======================================================================

/*
You're working as a data analyst for a popular website's dashboard analytics team. Your task is to analyze user visits to the dashboard and identify users who are highly engaged with the platform. The dashboard records user visits along with timestamps to provide insights into user activity patterns.
A user can visit the dashboard multiple times within a day. However, to be counted as separate visits, there should be a minimum gap of 60 minutes between consecutive visits. If the next visit occurs within 60 minutes of the previous one, it's considered part of the same visit.

 
Table: dashboard_visit
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| user_id     | varchar(10) |
| visit_time  | datetime    |
+-------------+-------------+
Write an SQL query to find total number of visits by each user along with number of distinct days user has visited the dashboard. While calculating the number of distinct days you have to consider a visit even if it is same as previous days visit.
So for example if there is a visit at 2024-01-12 23:30:00 and next visit at 2024-01-13 00:15:00 , The visit on 13th will not be considered as new visit because it is within 1 hour window of previous visit but number of days will be counted as 2 only, display the output in ascending order of user id.
*/


-- Write your SQL solution below:

```sql
SELECT 
    user_id,
    COUNT(DISTINCT visit_group) AS total_visits,
    COUNT(DISTINCT DATE(visit_time)) AS distinct_days
FROM (
    SELECT 
        user_id,
        visit_time,
        SUM(CASE 
            WHEN LAG(visit_time) OVER (PARTITION BY user_id ORDER BY visit_time) IS NULL 
                 OR EXTRACT(EPOCH FROM (visit_time - LAG(visit_time) OVER (PARTITION BY user_id ORDER BY visit_time))) / 60 >= 60
            THEN 1 
            ELSE 0 
        END) OVER (PARTITION BY user_id ORDER BY visit_time) AS visit_group
    FROM dashboard_visit
) subquery
GROUP BY user_id
ORDER BY user_id ASC;
```
