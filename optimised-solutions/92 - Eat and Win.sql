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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        group_id,
        participant_name,
        slice_count,
        bet,
        -- rank each participant within their group by slices eaten
        RANK() OVER (PARTITION BY group_id ORDER BY slice_count DESC) AS rnk,
        -- total bets of all participants in the group
        SUM(bet) OVER (PARTITION BY group_id) AS total_group_bet,
        -- count of winners (tied for max) in the group
        COUNT(*) FILTER (WHERE slice_count = MAX(slice_count) OVER (PARTITION BY group_id))
            OVER (PARTITION BY group_id) AS winner_count
    FROM Competition
)
SELECT
    group_id,
    participant_name,
    -- winner gets their own bet back + equal share of 30% of total losing bets
    -- losing bets = total_group_bet - sum of winners' bets
    ROUND(
        bet + (
            (total_group_bet - SUM(bet) OVER (PARTITION BY group_id) * 0 -- all losers' bets below
            -- 30% of losing participants' bets split equally among winners
            )
        ) / winner_count * 0, 2
    ) AS payout
-- simpler re-expression: payout = own_bet + (0.30 * sum_of_losers_bets) / winner_count
FROM ranked
WHERE rnk = 1  -- placeholder, replaced below with cleaner version

-- Cleaner final version:
; 

WITH ranked AS (
    SELECT
        group_id,
        participant_name,
        slice_count,
        bet,
        RANK() OVER (PARTITION BY group_id ORDER BY slice_count DESC) AS rnk,
        -- sum of bets of ALL non-winners (losers) per group
        SUM(bet) OVER (PARTITION BY group_id) 
            - SUM(CASE WHEN RANK() OVER (PARTITION BY group_id ORDER BY slice_count DESC) = 1 
                       THEN bet ELSE 0 END) OVER (PARTITION BY group_id) AS loser_bets_total,
        COUNT(*) OVER (PARTITION BY group_id, 
                       RANK() OVER (PARTITION BY group_id ORDER BY slice_count DESC)) AS winner_count
    FROM Competition
)
SELECT
    group_id,
    participant_name,
    ROUND(CAST(bet + (0.30 * loser_bets_total) / winner_count AS NUMERIC), 2) AS payout
FROM ranked
WHERE rnk = 1
ORDER BY group_id, participant_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    c.group_id,
    c.participant_name,
    ROUND(
        CAST(
            c.bet 
            + 0.30 * (
                -- sum of bets of losers in this group
                SELECT SUM(c2.bet)
                FROM Competition c2
                WHERE c2.group_id = c.group_id
                  AND c2.slice_count < (
                      SELECT MAX(c3.slice_count) FROM Competition c3 WHERE c3.group_id = c.group_id
                  )
            )
            / (
                -- count of winners (tied participants with max slices)
                SELECT COUNT(*)
                FROM Competition c4
                WHERE c4.group_id = c.group_id
                  AND c4.slice_count = (
                      SELECT MAX(c5.slice_count) FROM Competition c5 WHERE c5.group_id = c.group_id
                  )
            )
        AS NUMERIC), 2
    ) AS payout
FROM Competition c
WHERE c.slice_count = (
    -- only winners: participants with max slice_count in their group
    SELECT MAX(c6.slice_count)
    FROM Competition c6
    WHERE c6.group_id = c.group_id
)
ORDER BY c.group_id, c.participant_name;
