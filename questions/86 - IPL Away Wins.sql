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

```sql
SELECT 
  CASE 
    WHEN m1.home_team < m2.home_team THEN m1.home_team
    ELSE m2.home_team
  END AS team_1,
  CASE 
    WHEN m1.home_team < m2.home_team THEN m2.home_team
    ELSE m1.home_team
  END AS team_2
FROM Matches m1
JOIN Matches m2 
  ON m1.home_team = m2.away_team 
  AND m1.away_team = m2.home_team
WHERE m1.winner_team = m1.away_team
  AND m2.winner_team = m2.away_team
GROUP BY 
  CASE 
    WHEN m1.home_team < m2.home_team THEN m1.home_team
    ELSE m2.home_team
  END,
  CASE 
    WHEN m1.home_team < m2.home_team THEN m2.home_team
    ELSE m1.home_team
  END;
```
