-- ======================================================================
-- 33 - Average Order Value
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/33-average-order-value
-- ======================================================================

/*
Write an SQL query to determine the transaction date with the lowest average order value (AOV) among all dates recorded in the transaction table. Display the transaction date, its corresponding AOV, and the difference between the AOV for that date and the highest AOV for any day in the dataset. Round the result to 2 decimal places.

 
Table: transactions 
+--------------------+--------------+
| COLUMN_NAME        | DATA_TYPE    |
+--------------------+--------------+
| order_id           | int          |
| transaction_amount | decimal(5,2) |
| transaction_date   | date         |
| user_id            | int          |
+--------------------+--------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_aov AS (
    SELECT
        transaction_date,
        AVG(transaction_amount) AS aov
    FROM transactions
    GROUP BY transaction_date
),
stats AS (
    SELECT
        transaction_date,
        aov,
        MAX(aov) OVER () AS max_aov,
        MIN(aov) OVER () AS min_aov,
        RANK()   OVER (ORDER BY aov ASC) AS rnk
    FROM daily_aov
)
SELECT
    transaction_date,
    ROUND(aov, 2)                    AS avg_order_value,
    ROUND(aov - max_aov, 2)          AS difference_from_highest_aov
FROM stats
WHERE rnk = 1;  -- lowest AOV date(s)

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    t.transaction_date,
    ROUND(AVG(t.transaction_amount), 2)                             AS avg_order_value,
    ROUND(
        AVG(t.transaction_amount) - (
            -- highest AOV across all dates
            SELECT MAX(daily_max.daily_avg)
            FROM (
                SELECT AVG(transaction_amount) AS daily_avg
                FROM transactions
                GROUP BY transaction_date
            ) AS daily_max
        ), 2
    )                                                               AS difference_from_highest_aov
FROM transactions t
GROUP BY t.transaction_date
HAVING AVG(t.transaction_amount) = (
    -- lowest AOV across all dates
    SELECT MIN(daily_min.daily_avg)
    FROM (
        SELECT AVG(transaction_amount) AS daily_avg
        FROM transactions
        GROUP BY transaction_date
    ) AS daily_min
);
