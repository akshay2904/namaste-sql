-- ======================================================================
-- 145 - Inactive Users
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Linkedin
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/145-inactive-users-927cf069
-- ======================================================================

/*
You’re given two tables: users and events. The users table contains information about users, including the social media platform they belong to (platform column with values ‘LinkedIn’, ‘Meta’, or ‘Instagram’). The events table stores user interactions in the action column, which can be ‘like’, ‘comment’, or ‘post’. Please note that one user can belong to multiple social media platforms.

Write a query to calculate the percentage of users on each social media platform who have never liked or commented, rounded to two decimal places. Order the result by platform.

 
Table: users
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| user_id     | INTEGER  |
| name        | VARCHAR  | 
| platform    | VARCHAR  | 
+-------------+----------+Table: events
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| event_id    | INTEGER  |
| user_id     | INTEGER  |
| action      | VARCHAR  | 
| platform    | VARCHAR  | 
| created_at  | DATETIME | 
+-------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
  u.platform,
  ROUND(
    100.0 * COUNT(DISTINCT CASE 
      WHEN u.user_id NOT IN (
        SELECT DISTINCT user_id 
        FROM events 
        WHERE action IN ('like', 'comment')
      ) 
      THEN u.user_id 
    END) / COUNT(DISTINCT u.user_id),
    2
  ) AS percentage_never_liked_or_commented
FROM users u
GROUP BY u.platform
ORDER BY u.platform;
```
