-- ======================================================================
-- 89 - Netflix Device Type (PART-2)
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Netflix
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/89-netflix-device-type-part-2
-- ======================================================================

/*
In the Netflix viewing history dataset, you are tasked with identifying viewers who have a consistent viewing pattern across multiple devices. Specifically, viewers who have watched the same title on more than 1 device type. 
Write an SQL query to find users who have watched more number of titles on multiple devices than the number of titles they watched on single device. Output the user id , no of titles watched on multiple devices and no of titles watched on single device, display the output in ascending order of user_id.
Table:viewing_history
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| user_id     | int         |
| title       | varchar(20) |
| device_type | varchar(10) |
| watched_at  | datetime    |
+-------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    user_id,
    COUNT(CASE WHEN device_count > 1 THEN 1 END) AS titles_on_multiple_devices,
    COUNT(CASE WHEN device_count = 1 THEN 1 END) AS titles_on_single_device
FROM (
    SELECT 
        user_id,
        title,
        COUNT(DISTINCT device_type) AS device_count
    FROM viewing_history
    GROUP BY user_id, title
) title_device_counts
GROUP BY user_id
HAVING COUNT(CASE WHEN device_count > 1 THEN 1 END) > COUNT(CASE WHEN device_count = 1 THEN 1 END)
ORDER BY user_id ASC;
```
