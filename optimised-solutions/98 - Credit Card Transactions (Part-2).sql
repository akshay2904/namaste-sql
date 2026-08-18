-- ======================================================================
-- 98 - Credit Card Transactions (Part-2)
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Paypal
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/98-credit-card-transactions-part-2
-- ======================================================================

/*
You are given a history of credit card transaction data for the people of India across cities as below. Your task is to find out highest spend card type and lowest spent card type for each city, display the output in ascending order of city.

 
Table: credit_card_transactions
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| transaction_id   | int         |
| city             | varchar(10) |
| transaction_date | date        |
| card_type        | varchar(12) |
| gender           | varchar(1)  |
| amount           | int         |
+------------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH city_card_totals AS (
    SELECT
        city,
        card_type,
        SUM(amount) AS total_spend
    FROM credit_card_transactions
    GROUP BY city, card_type
),
ranked AS (
    SELECT
        city,
        card_type,
        total_spend,
        RANK() OVER (PARTITION BY city ORDER BY total_spend DESC) AS rank_high,
        RANK() OVER (PARTITION BY city ORDER BY total_spend ASC)  AS rank_low
    FROM city_card_totals
)
SELECT
    city,
    MAX(CASE WHEN rank_high = 1 THEN card_type END) AS highest_spend_card_type,
    MAX(CASE WHEN rank_low  = 1 THEN card_type END) AS lowest_spend_card_type
FROM ranked
WHERE rank_high = 1 OR rank_low = 1
GROUP BY city
ORDER BY city;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH city_card_totals AS (
    SELECT
        city,
        card_type,
        SUM(amount) AS total_spend
    FROM credit_card_transactions
    GROUP BY city, card_type
),
city_max AS (
    -- highest total spend per city
    SELECT cct.city, cct.card_type AS highest_spend_card_type
    FROM city_card_totals cct
    INNER JOIN (
        SELECT city, MAX(total_spend) AS max_spend
        FROM city_card_totals
        GROUP BY city
    ) mx ON cct.city = mx.city AND cct.total_spend = mx.max_spend
),
city_min AS (
    -- lowest total spend per city
    SELECT cct.city, cct.card_type AS lowest_spend_card_type
    FROM city_card_totals cct
    INNER JOIN (
        SELECT city, MIN(total_spend) AS min_spend
        FROM city_card_totals
        GROUP BY city
    ) mn ON cct.city = mn.city AND cct.total_spend = mn.min_spend
)
SELECT
    city_max.city,
    city_max.highest_spend_card_type,
    city_min.lowest_spend_card_type
FROM city_max
INNER JOIN city_min ON city_max.city = city_min.city
ORDER BY city_max.city;
