-- ======================================================================
-- 135 - Music Lovers
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Spotify
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/135-music-lovers
-- ======================================================================

/*
At Spotify, we track user activity to understand their engagement with the platform. One of the key metrics we focus on is how consistently a user listens to music each day. A user is considered "consistent" if they have login session every single day since their first login.

Your task is to identify users who have logged in and listened to music every single day since their first login date until today.

Note: Dates are as per UTC time zone.

 

Table: user_sessions
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| user_id         | int      |
| login_timestamp | datetime | 
+-----------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT DISTINCT u1.user_id
FROM user_sessions u1
GROUP BY u1.user_id
HAVING COUNT(DISTINCT DATE(u1.login_timestamp)) = 
       DATEDIFF(DATE(MAX(u1.login_timestamp)), DATE(MIN(u1.login_timestamp))) + 1
```

This solution works by:
1. Grouping sessions by user_id
2. Counting the number of distinct days the user logged in
3. Calculating the expected number of days between their first and last login (inclusive)
4. Filtering for users where these two counts match, meaning they logged in every single day
