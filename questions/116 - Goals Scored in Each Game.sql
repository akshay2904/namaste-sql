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

```sql
SELECT 
    g.match_id,
    g.match_date,
    t1.name AS team1,
    COALESCE(SUM(CASE WHEN go.team_id = g.team1 THEN 1 ELSE 0 END), 0) AS score1,
    t2.name AS team2,
    COALESCE(SUM(CASE WHEN go.team_id = g.team2 THEN 1 ELSE 0 END), 0) AS score2
FROM game g
JOIN team t1 ON g.team1 = t1.id
JOIN team t2 ON g.team2 = t2.id
LEFT JOIN goal go ON g.match_id = go.match_id
GROUP BY g.match_id, g.match_date, t1.name, t2.name
ORDER BY g.match_id;
```
