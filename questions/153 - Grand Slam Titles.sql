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

```sql
SELECT 
    p.player_id,
    p.player_name,
    COALESCE(SUM(grand_slam_wins.count), 0) AS grand_slams_count
FROM players p
LEFT JOIN (
    -- Unpivot the championships data to count wins for each player
    SELECT wimbledon AS player_id, 1 AS count FROM championships WHERE wimbledon IS NOT NULL
    UNION ALL
    SELECT fr_open AS player_id, 1 AS count FROM championships WHERE fr_open IS NOT NULL
    UNION ALL
    SELECT us_open AS player_id, 1 AS count FROM championships WHERE us_open IS NOT NULL
    UNION ALL
    SELECT au_open AS player_id, 1 AS count FROM championships WHERE au_open IS NOT NULL
) grand_slam_wins ON p.player_id = grand_slam_wins.player_id
GROUP BY p.player_id, p.player_name
ORDER BY grand_slams_count DESC;
```
