-- ======================================================================
-- 115 - Sequence Expansion
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Zepto
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/115-sequence-expansion
-- ======================================================================

/*
You have a table named numbers containing a single column n. You are required to generate an output that expands each number n into a sequence where the number appears n times.

 
Table: numbers 
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| n           |   int     |    
+-------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH RECURSIVE series AS (
    -- Anchor: start with 1
    SELECT 1 AS idx
    UNION ALL
    -- Recursive: increment until we reach the max n
    SELECT idx + 1
    FROM series
    JOIN (SELECT MAX(n) AS max_n FROM numbers) m ON idx < m.max_n
)
SELECT num.n
FROM numbers num
JOIN series s ON s.idx <= num.n
ORDER BY num.n;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Generate a sequence of integers up to the max value of n
-- then cross join with numbers, keeping only rows where seq <= n
SELECT num.n
FROM numbers num
JOIN (
    -- Generate integers 1..max(n) using generate_series
    SELECT generate_series(1, (SELECT MAX(n) FROM numbers)) AS seq
) gs ON gs.seq <= num.n
ORDER BY num.n;
