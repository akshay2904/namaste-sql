-- ======================================================================
-- 116 - Goals Scored in Each Game
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Agoda
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/116-goals-scored-in-each-game
-- ======================================================================

/*
Please refer to the 3 tables below from a football tournament. Write an SQL which lists every game with the goals scored by each team. The result set should show: match id, match date, team1, score1, team2, score2. Sort the result by match id.

Please note that score1 and score2 should be number of goals scored by team1 and team2 respectively.

 
Table: team 
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| id          | int         |
| name        | varchar(20) |
| coach       | varchar(20) |
+-------------+-------------+Table: game
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| match_id    | int         |
| match_date  | date        |
| stadium     | varchar(20) |
| team1       | int         |
| team2       | int         |
+-------------+-------------+Table: goal 
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| match_id    | int         |
| team_id     | int         |
| player      | varchar(20) |
| goal_time   | time        |
+-------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH goal_counts AS (
    -- Pre-aggregate goals per match per team in a single scan
    SELECT
        match_id,
        team_id,
        COUNT(*) AS goals
    FROM goal
    GROUP BY match_id, team_id
)
SELECT
    g.match_id,
    g.match_date,
    t1.name                          AS team1,
    COALESCE(gc1.goals, 0)           AS score1,
    t2.name                          AS team2,
    COALESCE(gc2.goals, 0)           AS score2
FROM game g
JOIN team t1  ON t1.id = g.team1
JOIN team t2  ON t2.id = g.team2
LEFT JOIN goal_counts gc1 ON gc1.match_id = g.match_id AND gc1.team_id = g.team1
LEFT JOIN goal_counts gc2 ON gc2.match_id = g.match_id AND gc2.team_id = g.team2
ORDER BY g.match_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    g.match_id,
    g.match_date,
    t1.name                                                        AS team1,
    -- Correlated subquery counts goals for team1 in this match
    (SELECT COUNT(*)
     FROM goal gl
     WHERE gl.match_id = g.match_id
       AND gl.team_id  = g.team1)                                  AS score1,
    t2.name                                                        AS team2,
    -- Correlated subquery counts goals for team2 in this match
    (SELECT COUNT(*)
     FROM goal gl
     WHERE gl.match_id = g.match_id
       AND gl.team_id  = g.team2)                                  AS score2
FROM game g
JOIN team t1 ON t1.id = g.team1
JOIN team t2 ON t2.id = g.team2
ORDER BY g.match_id;
