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

```sql
SELECT 
    team_name,
    COUNT(*) as matches_played,
    SUM(CASE WHEN winner = team_name THEN 1 ELSE 0 END) as wins,
    SUM(CASE WHEN winner != team_name AND winner IS NOT NULL THEN 1 ELSE 0 END) as losses,
    SUM(CASE 
        WHEN winner = team_name THEN 2 
        WHEN winner IS NULL THEN 1 
        ELSE 0 
    END) as points
FROM (
    SELECT team_1 as team_name, winner FROM icc_world_cup
    UNION ALL
    SELECT team_2 as team_name, winner FROM icc_world_cup
) match_data
GROUP BY team_name
ORDER BY team_name ASC;
```
