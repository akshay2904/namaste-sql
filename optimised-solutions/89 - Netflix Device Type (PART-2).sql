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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH title_device_counts AS (
    -- Count distinct device types per user per title
    SELECT 
        user_id,
        title,
        COUNT(DISTINCT device_type) AS device_count
    FROM viewing_history
    GROUP BY user_id, title
),
user_category_counts AS (
    -- Categorize each title as multi-device or single-device and count
    SELECT
        user_id,
        COUNT(CASE WHEN device_count > 1 THEN 1 END) AS multi_device_titles,
        COUNT(CASE WHEN device_count = 1 THEN 1 END) AS single_device_titles
    FROM title_device_counts
    GROUP BY user_id
)
SELECT
    user_id,
    multi_device_titles,
    single_device_titles
FROM user_category_counts
WHERE multi_device_titles > single_device_titles
ORDER BY user_id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    m.user_id,
    m.multi_device_titles,
    s.single_device_titles
FROM
    -- Subquery: count titles watched on more than 1 device type per user
    (
        SELECT 
            user_id,
            COUNT(*) AS multi_device_titles
        FROM (
            SELECT user_id, title
            FROM viewing_history
            GROUP BY user_id, title
            HAVING COUNT(DISTINCT device_type) > 1
        ) AS multi
        GROUP BY user_id
    ) m
JOIN
    -- Subquery: count titles watched on exactly 1 device type per user
    (
        SELECT 
            user_id,
            COUNT(*) AS single_device_titles
        FROM (
            SELECT user_id, title
            FROM viewing_history
            GROUP BY user_id, title
            HAVING COUNT(DISTINCT device_type) = 1
        ) AS single
        GROUP BY user_id
    ) s
ON m.user_id = s.user_id
WHERE m.multi_device_titles > s.single_device_titles
ORDER BY m.user_id ASC;
