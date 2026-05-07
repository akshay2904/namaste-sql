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

```sql
WITH player_scores AS (
  -- Calculate total points for each player from matches where they are the first player
  SELECT first_player AS player_id, SUM(first_score) AS total_score
  FROM matches
  GROUP BY first_player
  
  UNION ALL
  
  -- Calculate total points for each player from matches where they are the second player
  SELECT second_player AS player_id, SUM(second_score) AS total_score
  FROM matches
  GROUP BY second_player
),
aggregated_scores AS (
  -- Aggregate scores for players who appear in both roles
  SELECT player_id, SUM(total_score) AS total_score
  FROM player_scores
  GROUP BY player_id
),
ranked_players AS (
  -- Rank players within each group by total score (descending) and player_id (descending)
  SELECT 
    p.group_id,
    p.player_id,
    a.total_score,
    ROW_NUMBER() OVER (PARTITION BY p.group_id ORDER BY a.total_score DESC, p.player_id DESC) AS rnk
  FROM players p
  LEFT JOIN aggregated_scores a ON p.player_id = a.player_id
)
SELECT group_id, player_id
FROM ranked_players
WHERE rnk = 1
ORDER BY group_id;
```
