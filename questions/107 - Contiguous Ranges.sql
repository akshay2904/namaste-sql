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

```sql
SELECT 
    MIN(log_id) AS start_id,
    MAX(log_id) AS end_id
FROM (
    SELECT 
        log_id,
        ROW_NUMBER() OVER (ORDER BY log_id) AS rn,
        log_id - ROW_NUMBER() OVER (ORDER BY log_id) AS grp
    FROM logs
) subquery
GROUP BY grp
ORDER BY start_id;
```
