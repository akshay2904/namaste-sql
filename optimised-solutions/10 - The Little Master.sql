-- ======================================================================
-- 10 - The Little Master
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/10-the-little-master
-- ======================================================================

/*
Sachin Tendulkar - Also known as little master. You are given runs scored by Sachin in his first 10 matches. You need to write an SQL to get match number when he completed 500 runs and his batting average at the end of 10 matches.

Batting Average = (Total runs scored) / (no of times batsman got out)

Round the result to 2 decimal places.

 
Table: sachin
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| match_no    | int         |
| runs_scored | int         |
| status      | varchar(10) |
+-------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH cumulative AS (
    SELECT
        match_no,
        runs_scored,
        status,
        SUM(runs_scored) OVER (ORDER BY match_no) AS cumulative_runs
    FROM sachin
),
match_500 AS (
    -- First match where cumulative runs reach or exceed 500
    SELECT MIN(match_no) AS match_when_500
    FROM cumulative
    WHERE cumulative_runs >= 500
),
avg_calc AS (
    -- Batting average over all 10 matches
    SELECT
        ROUND(
            SUM(runs_scored)::NUMERIC / NULLIF(SUM(CASE WHEN status = 'out' THEN 1 ELSE 0 END), 0),
            2
        ) AS batting_average
    FROM sachin
)
SELECT
    m.match_when_500,
    a.batting_average
FROM match_500 m
CROSS JOIN avg_calc a;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    (
        -- Find the first match where the running total of runs hits 500
        SELECT MIN(s1.match_no)
        FROM sachin s1
        WHERE (
            SELECT SUM(s2.runs_scored)
            FROM sachin s2
            WHERE s2.match_no <= s1.match_no
        ) >= 500
    ) AS match_when_500,
    (
        -- Calculate batting average across all 10 matches
        SELECT ROUND(
            SUM(runs_scored)::NUMERIC /
            NULLIF(SUM(CASE WHEN status = 'out' THEN 1 ELSE 0 END), 0),
            2
        )
        FROM sachin
    ) AS batting_average;
