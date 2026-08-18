-- ======================================================================
-- 24 - Account Balance
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Paypal
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/24-account-balance
-- ======================================================================

/*
You are given a list of users and their opening account balance along with the transactions done by them. Write a SQL to calculate their account balance at the end of all the transactions. Please note that users can do transactions among themselves as well, display the output in ascending order of the final balance.

 

Table: users
+-----------------+-------------+
| COLUMN_NAME     | DATA_TYPE   |
+-----------------+-------------+
| user_id         | int         |
| username        | varchar(10) |
| opening_balance | int         |
+-----------------+-------------+

Table: transactions
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| id          | int       |
| from_userid | int       |
| to_userid   | int       |
| amount      | int       |
+-------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH balance_changes AS (
    -- Aggregate all debits and credits per user in a single pass using UNION ALL
    SELECT from_userid AS user_id, -amount AS net_change FROM transactions
    UNION ALL
    SELECT to_userid   AS user_id,  amount AS net_change FROM transactions
),
aggregated AS (
    SELECT user_id, SUM(net_change) AS total_change
    FROM balance_changes
    GROUP BY user_id
)
SELECT
    u.user_id,
    u.username,
    u.opening_balance + COALESCE(a.total_change, 0) AS final_balance
FROM users u
LEFT JOIN aggregated a ON u.user_id = a.user_id
ORDER BY final_balance ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    u.user_id,
    u.username,
    u.opening_balance
        -- subtract total amount sent by this user
        - COALESCE((
            SELECT SUM(t.amount)
            FROM transactions t
            WHERE t.from_userid = u.user_id
          ), 0)
        -- add total amount received by this user
        + COALESCE((
            SELECT SUM(t.amount)
            FROM transactions t
            WHERE t.to_userid = u.user_id
          ), 0)
    AS final_balance
FROM users u
ORDER BY final_balance ASC;
