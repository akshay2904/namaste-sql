-- ======================================================================
-- 153 - Grand Slam Titles
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Doordash
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/153-grand-slam-titles
-- ======================================================================

/*
In professional tennis, there are four major tournaments that make up the Grand Slam: Wimbledon, French Open, US Open, and Australian Open. Each year, these tournaments declare one winner, and winning any of them is a major achievement for a tennis player. In championships table the wimbledon, fr_open, us_open and au_open columns have the winner player id.

You are given data from a tennis database. Your task is to write a query to report the total number of Grand Slam tournaments won by each player. The result should include all players, even those who have never won a tournament. For such players, the count should be 0.

Return the result with columns: player_id, player_name, and grand_slams_count. The result should be sorted by grand_slams_count in descending order.

 
Table: players
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| player_id    | INT      |
| player_name  | varchar  | 
+-------------------------+

Table: championships
+-------------+---------+
| COLUMN_NAME |DATA_TYPE|
+-------------+---------+
| year        | INT     | 
| wimbledon   | INT     |
| fr_open     | INT     | 
| us_open     | INT     | 
| au_open     | INT     | 
+-----------------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH all_winners AS (
    -- Unpivot all four tournament columns into a single column of winner IDs
    SELECT wimbledon AS player_id FROM championships
    UNION ALL
    SELECT fr_open   FROM championships
    UNION ALL
    SELECT us_open   FROM championships
    UNION ALL
    SELECT au_open   FROM championships
),
win_counts AS (
    SELECT player_id, COUNT(*) AS grand_slams_count
    FROM all_winners
    GROUP BY player_id
)
SELECT
    p.player_id,
    p.player_name,
    COALESCE(wc.grand_slams_count, 0) AS grand_slams_count
FROM players p
LEFT JOIN win_counts wc ON p.player_id = wc.player_id
ORDER BY grand_slams_count DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    p.player_id,
    p.player_name,
    -- Count how many times this player appears across all four tournament columns
    (
        SELECT COUNT(*) FROM championships c WHERE c.wimbledon = p.player_id
    ) +
    (
        SELECT COUNT(*) FROM championships c WHERE c.fr_open = p.player_id
    ) +
    (
        SELECT COUNT(*) FROM championships c WHERE c.us_open = p.player_id
    ) +
    (
        SELECT COUNT(*) FROM championships c WHERE c.au_open = p.player_id
    ) AS grand_slams_count
FROM players p
ORDER BY grand_slams_count DESC;
