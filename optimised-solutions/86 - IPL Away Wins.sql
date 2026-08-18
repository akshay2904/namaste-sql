-- ======================================================================
-- 86 - IPL Away Wins
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/86-ipl-away-wins
-- ======================================================================

/*
In the Indian Premier League (IPL), each team plays two matches against every other team: one at their home venue and one at their opponent's venue. We want to identify team combinations where each team wins the away match but loses the home match against the same opponent. Write an SQL query to find such team combinations, where each team wins at the opponent's venue but loses at their own home venue.

 
Table: Matches
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| away_team   | varchar(10) |
| home_team   | varchar(10) |
| match_id    | int         |
| winner_team | varchar(10) |
+-------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH match_results AS (
    SELECT
        home_team,
        away_team,
        -- Flag: did the away team win this match?
        CASE WHEN winner_team = away_team THEN 1 ELSE 0 END AS away_team_won
    FROM Matches
),
team_pairs AS (
    SELECT
        -- Normalize team pair so (A,B) and (B,A) can be joined
        m1.home_team  AS team1,
        m1.away_team  AS team2,
        m1.away_team_won AS team2_won_away,   -- team2 played away at team1's ground
        m2.away_team_won AS team1_won_away    -- team1 played away at team2's ground
    FROM match_results m1
    JOIN match_results m2
        ON m1.home_team = m2.away_team        -- team1 hosted team2, team2 hosted team1
        AND m1.away_team = m2.home_team
)
SELECT
    team1,
    team2
FROM team_pairs
WHERE
    team2_won_away = 1   -- team2 won at team1's home (team1 lost at home)
    AND team1_won_away = 1  -- team1 won at team2's home (team2 lost at home)
ORDER BY team1, team2;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT DISTINCT
    m1.home_team AS team1,
    m1.away_team AS team2
FROM Matches m1
JOIN Matches m2
    ON m1.home_team = m2.away_team   -- same two teams, reversed roles
    AND m1.away_team = m2.home_team
WHERE
    -- In m1: away_team (team2) wins at team1's home => team1 loses at home
    m1.winner_team = m1.away_team
    AND
    -- In m2: away_team (team1) wins at team2's home => team2 loses at home
    m2.winner_team = m2.away_team
ORDER BY team1, team2;
