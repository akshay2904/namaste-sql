-- ======================================================================
-- 42 - Points Table
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/42-points-table
-- ======================================================================

/*
You are given table of cricket match played in a ICC cricket tournament with the details of winner for each match. You need to derive a points table using below rules.
1- For each win a team gets 2 points. 
2- For a loss team gets 0 points.
3- In case of a draw both the team gets 1 point each.
Display team name , matches played, # of wins , # of losses and points.  Sort output in ascending order of team name.

 
Table: icc_world_cup 
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| team_1      | varchar(10) |
| team_2      | varchar(10) |
| winner      | varchar(10) |
+-------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH all_teams AS (
    -- Unpivot: each match appears twice, once per team
    SELECT team_1 AS team, winner FROM icc_world_cup
    UNION ALL
    SELECT team_2 AS team, winner FROM icc_world_cup
)
SELECT
    team,
    COUNT(*)                                                        AS matches_played,
    COUNT(*) FILTER (WHERE winner = team)                           AS wins,
    COUNT(*) FILTER (WHERE winner <> team AND winner <> 'Draw')    AS losses,
    SUM(
        CASE
            WHEN winner = team   THEN 2   -- win
            WHEN winner = 'Draw' THEN 1   -- draw
            ELSE                      0   -- loss
        END
    )                                                               AS points
FROM all_teams
GROUP BY team
ORDER BY team ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    team,
    COUNT(*)                                                          AS matches_played,
    SUM(CASE WHEN winner = team THEN 1 ELSE 0 END)                   AS wins,
    SUM(CASE WHEN winner <> team AND winner <> 'Draw' THEN 1 ELSE 0 END) AS losses,
    SUM(
        CASE
            WHEN winner = team   THEN 2
            WHEN winner = 'Draw' THEN 1
            ELSE                      0
        END
    )                                                                 AS points
FROM (
    -- team_1 perspective
    SELECT team_1 AS team, winner FROM icc_world_cup
    UNION ALL
    -- team_2 perspective
    SELECT team_2 AS team, winner FROM icc_world_cup
) AS all_matches
GROUP BY team
ORDER BY team ASC;
