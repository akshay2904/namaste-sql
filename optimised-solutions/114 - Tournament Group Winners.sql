-- ======================================================================
-- 114 - Tournament Group Winners
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : E&y
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/114-tournament-group-winners
-- ======================================================================

/*
You are given two tables, players and matches, with the following structure.

Each record in the table players represents a single player in the tournament. The column player_id contains the ID of each player. The column group_id contains the ID of the group each player belongs to.

 
Table: players 
+-----------------+----------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| player_id       | int      |    
| group_id        | int      |
+-----------------+----------+
Each record in the table matches represents a single match in the group stage. The column first_player (second_player) contains the ID of the first player (second player) in each match. The column first_score (second_score) contains the number of points scored by the first player (second player) in each match. You may assume that, in each match, players belong to the same group.

 
Table: matches 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| match_id      | int      |    
| first_player  | int      |
| second_player | int      |
| first_score   | int      |
| second_score  | int      |
+---------------+----------+
Write an SQL to compute the winner in each group. The winner in each group is the player who scored the maximum total number of points within the group. If there is more than one such player, the winner is the one with the highest ID. Write an SQL query that returns a table containing the winner of each group. Each record should contain the ID of the group and the ID of the winner in this group. Records should be sorted by group id.
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH player_scores AS (
    -- Combine scores from both sides of matches
    SELECT first_player AS player_id, SUM(first_score) AS total_score
    FROM matches
    GROUP BY first_player
    UNION ALL
    SELECT second_player AS player_id, SUM(second_score) AS total_score
    FROM matches
    GROUP BY second_player
),
aggregated_scores AS (
    -- Sum across all matches per player
    SELECT player_id, SUM(total_score) AS total_score
    FROM player_scores
    GROUP BY player_id
),
ranked AS (
    SELECT
        p.group_id,
        p.player_id,
        COALESCE(s.total_score, 0) AS total_score,
        -- Rank by score DESC, then player_id DESC to break ties with highest ID
        RANK() OVER (
            PARTITION BY p.group_id
            ORDER BY COALESCE(s.total_score, 0) DESC, p.player_id DESC
        ) AS rnk
    FROM players p
    LEFT JOIN aggregated_scores s ON p.player_id = s.player_id
)
SELECT group_id, player_id AS winner
FROM ranked
WHERE rnk = 1
ORDER BY group_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH player_total_scores AS (
    -- Get total score per player by unioning both sides
    SELECT player_id, SUM(score) AS total_score
    FROM (
        SELECT first_player AS player_id, first_score AS score FROM matches
        UNION ALL
        SELECT second_player AS player_id, second_score AS score FROM matches
    ) all_scores
    GROUP BY player_id
),
group_scores AS (
    -- Join with players to get group info
    SELECT
        p.group_id,
        p.player_id,
        COALESCE(pts.total_score, 0) AS total_score
    FROM players p
    LEFT JOIN player_total_scores pts ON p.player_id = pts.player_id
),
group_max AS (
    -- Find the maximum score per group
    SELECT group_id, MAX(total_score) AS max_score
    FROM group_scores
    GROUP BY group_id
),
candidates AS (
    -- Find all players who have the maximum score in their group
    SELECT gs.group_id, gs.player_id
    FROM group_scores gs
    JOIN group_max gm
        ON gs.group_id = gm.group_id
        AND gs.total_score = gm.max_score
)
-- Among tied candidates, pick the one with the highest player_id
SELECT group_id, MAX(player_id) AS winner
FROM candidates
GROUP BY group_id
ORDER BY group_id;
