-- ======================================================================
-- 107 - Contiguous Ranges
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Microsoft
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/107-contiguous-ranges
-- ======================================================================

/*
Write an SQL query to find all the contiguous ranges of log_id values.

 
Table: logs
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| log_id      | int        |
+-------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Use the classic "gaps and islands" technique with ROW_NUMBER
-- If log_id - ROW_NUMBER() is constant, rows belong to the same contiguous group
WITH grouped AS (
    SELECT
        log_id,
        log_id - ROW_NUMBER() OVER (ORDER BY log_id) AS grp
    FROM logs
)
SELECT
    MIN(log_id) AS start_id,
    MAX(log_id) AS end_id
FROM grouped
GROUP BY grp
ORDER BY start_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- A log_id is a "range start" if (log_id - 1) does not exist in the table
-- A log_id is a "range end"   if (log_id + 1) does not exist in the table
-- Join each start to its corresponding end
SELECT
    s.log_id AS start_id,
    MIN(e.log_id) AS end_id
FROM
    -- Find all range starts: no preceding consecutive id exists
    (SELECT log_id
     FROM logs l1
     WHERE NOT EXISTS (
         SELECT 1 FROM logs l2 WHERE l2.log_id = l1.log_id - 1
     )) s
JOIN
    -- Find all range ends: no following consecutive id exists
    (SELECT log_id
     FROM logs l3
     WHERE NOT EXISTS (
         SELECT 1 FROM logs l4 WHERE l4.log_id = l3.log_id + 1
     )) e
ON s.log_id <= e.log_id
GROUP BY s.log_id
ORDER BY start_id;
