-- ======================================================================
-- 88 - Netflix Device Type (PART-1)
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Netflix
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/88-netflix-device-type-part-1
-- ======================================================================

/*
In the Netflix dataset containing information about viewers and their viewing history, devise a query to identify viewers who primarily use mobile devices for viewing, but occasionally switch to other devices. Specifically, find viewers who have watched at least 75% of their total viewing time on mobile devices but have also used at least one other devices such as tablets or smart TVs for viewing. Provide the user ID and the percentage of viewing time spent on mobile devices. Round the result to nearest integer.

 
Table: viewing_history
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| user_id     | int          |
| title       | varchar(20)  |
| device_type | varchar(10)  |
| watch_mins  | int          |
+-------------+--------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    user_id,
    ROUND(100.0 * SUM(CASE WHEN device_type = 'mobile' THEN watch_mins ELSE 0 END) / 
          SUM(watch_mins)) AS mobile_viewing_percentage
FROM viewing_history
GROUP BY user_id
HAVING 
    -- Mobile viewing is at least 75% of total
    100.0 * SUM(CASE WHEN device_type = 'mobile' THEN watch_mins ELSE 0 END) / 
    SUM(watch_mins) >= 75
    -- User has used at least one other device (not just mobile)
    AND COUNT(DISTINCT device_type) > 1
ORDER BY user_id;
```
