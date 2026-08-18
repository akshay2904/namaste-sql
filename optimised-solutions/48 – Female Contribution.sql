-- ======================================================================
-- 48 – Female Contribution
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/48-female-contribution
-- ======================================================================

/*
You are given a history of credit card transaction data for the people of India across cities. Write an SQL to find percentage contribution of spends by females in each city.  Round the percentage to 2 decimal places. Display city, total spend , female spend and female contribution in ascending order of city.

 
Table: credit_card_transactions
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| amount           | int         |
| card_type        | varchar(10) |
| city             | varchar(10) |
| gender           | varchar(1)  |
| transaction_date | date        |
| transaction_id   | int         |
+------------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH city_stats AS (
    SELECT
        city,
        SUM(amount) AS total_spend,
        SUM(CASE WHEN gender = 'F' THEN amount ELSE 0 END) AS female_spend
    FROM credit_card_transactions
    GROUP BY city
)
SELECT
    city,
    total_spend,
    female_spend,
    ROUND((female_spend * 100.0) / total_spend, 2) AS female_contribution_pct
FROM city_stats
ORDER BY city ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    t.city,
    t.total_spend,
    f.female_spend,
    ROUND((f.female_spend * 100.0) / t.total_spend, 2) AS female_contribution_pct
FROM
    -- total spend per city
    (
        SELECT city, SUM(amount) AS total_spend
        FROM credit_card_transactions
        GROUP BY city
    ) t
    -- female spend per city
    JOIN (
        SELECT city, SUM(amount) AS female_spend
        FROM credit_card_transactions
        WHERE gender = 'F'
        GROUP BY city
    ) f ON t.city = f.city
ORDER BY t.city ASC;
