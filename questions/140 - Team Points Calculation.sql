-- ======================================================================
-- 140 - Team Points Calculation
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Uber
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/140-team-points-calculation
-- ======================================================================

/*
Given a list of matches in the group stage of the football World Cup, compute the number of points each team currently has.

You are given two tables, "teams" and "matches", with the following structures:

 
Table: teams
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| team_id     | int      |
| team_name   | VARCHAR  | 
+-------------+----------+Table: matches
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| match_id    | int      |
| host_team   | int      | 
| guest_team  | int      | 
| host_goals  | int      | 
| guest_goals | int      | 
+-------------+----------+
 

You need to compute the total number of points each team has scored after all the matches described in the table. The scoring rules are as follows:

• If a team wins a match (scores more goals than the other team), it receives 3 points.
• If a team draws a match (scores exactly the same number of goals as the opponent), it receives 1 point.
• If a team loses a match (scores fewer goals than the opponent), it receives no points.

Write an SQL query that returns all the teams ids along with its name and the number of points it received after all described matches ("num_points"). The table should be ordered by "num_points" (in decreasing order). In case of a tie, order the rows by "team_id" (in increasing order).
*/


-- Write your SQL solution below:

```sql
WITH team_points AS (
  -- Points for host teams
  SELECT 
    host_team AS team_id,
    CASE 
      WHEN host_goals > guest_goals THEN 3
      WHEN host_goals = guest_goals THEN 1
      ELSE 0
    END AS points
  FROM matches
  
  UNION ALL
  
  -- Points for guest teams
  SELECT 
    guest_team AS team_id,
    CASE 
      WHEN guest_goals > host_goals THEN 3
      WHEN guest_goals = host_goals THEN 1
      ELSE 0
    END AS points
  FROM matches
)
SELECT 
  t.team_id,
  t.team_name,
  COALESCE(SUM(tp.points), 0) AS num_points
FROM teams t
LEFT JOIN team_points tp ON t.team_id = tp.team_id
GROUP BY t.team_id, t.team_name
ORDER BY num_points DESC, t.team_id ASC;
```
