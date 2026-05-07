-- ======================================================================
-- 92 - Eat and Win
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/92-eat-and-win
-- ======================================================================

/*
A pizza eating competition is organized. All the participants are organized into different groups. In a contest , A participant who eat the most pieces of pizza is the winner and recieves their original bet plus 30% of all losing participants bets. In case of a tie all winning participants will get equal share (of 30%) divided among them .Return the winning participants' names for each group and amount of their payout(round to 2 decimal places) . ordered ascending by group_id , participant_name.

 
Tables: Competition
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| group_id         | int         |
| participant_name | varchar(10) |
| slice_count      | int         |
| bet              | int         |
+------------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    c.group_id,
    c.participant_name,
    ROUND(c.bet + (0.30 * losing_bets.total_losing_bets / winner_count.winners_in_group), 2) AS payout
FROM 
    Competition c
    INNER JOIN (
        SELECT 
            group_id,
            MAX(slice_count) AS max_slices
        FROM 
            Competition
        GROUP BY 
            group_id
    ) max_slices ON c.group_id = max_slices.group_id AND c.slice_count = max_slices.max_slices
    INNER JOIN (
        SELECT 
            group_id,
            COUNT(*) AS winners_in_group
        FROM 
            Competition
        WHERE 
            (group_id, slice_count) IN (
                SELECT 
                    group_id,
                    MAX(slice_count)
                FROM 
                    Competition
                GROUP BY 
                    group_id
            )
        GROUP BY 
            group_id
    ) winner_count ON c.group_id = winner_count.group_id
    INNER JOIN (
        SELECT 
            group_id,
            SUM(bet) AS total_losing_bets
        FROM 
            Competition
        WHERE 
            (group_id, slice_count) NOT IN (
                SELECT 
                    group_id,
                    MAX(slice_count)
                FROM 
                    Competition
                GROUP BY 
                    group_id
            )
        GROUP BY 
            group_id
    ) losing_bets ON c.group_id = losing_bets.group_id
ORDER BY 
    c.group_id ASC,
    c.participant_name ASC;
```
