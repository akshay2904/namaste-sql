-- ======================================================================
-- 49 - Credit Card Transactions (Part-1)
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/49-credit-card-transactions-part-1
-- ======================================================================

/*
You are given a history of credit card transaction data for the people of India across cities . Write an SQL to find how many days each city took to reach cumulative spend of 1500 from its first day of transactions. 

Display city, first transaction date , date of 1500 spend and # of days in the ascending order of city.

 
Table: credit_card_transactions
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| transaction_id   | int         |
| transaction_date | date        |
| amount           | int         |
| card_type        | varchar(12) |
| city             | varchar(20) |
| gender           | varchar(1)  |
+------------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH cumulative_spend AS (
    SELECT
        city,
        transaction_date,
        SUM(amount) OVER (PARTITION BY city ORDER BY transaction_date, transaction_id) AS running_total,
        MIN(transaction_date) OVER (PARTITION BY city) AS first_transaction_date
    FROM credit_card_transactions
),
first_crossing AS (
    -- Get the earliest date where cumulative spend first reaches or exceeds 1500
    SELECT DISTINCT ON (city)
        city,
        first_transaction_date,
        transaction_date AS date_of_1500_spend
    FROM cumulative_spend
    WHERE running_total >= 1500
    ORDER BY city, transaction_date
)
SELECT
    city,
    first_transaction_date,
    date_of_1500_spend,
    (date_of_1500_spend - first_transaction_date) AS num_of_days
FROM first_crossing
ORDER BY city;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH daily_spend AS (
    -- Aggregate amount per city per day to handle multiple transactions on same day
    SELECT
        city,
        transaction_date,
        SUM(amount) AS daily_amount
    FROM credit_card_transactions
    GROUP BY city, transaction_date
),
city_first_date AS (
    -- Get first transaction date for each city
    SELECT
        city,
        MIN(transaction_date) AS first_transaction_date
    FROM credit_card_transactions
    GROUP BY city
),
date_of_1500 AS (
    -- For each city and date, compute cumulative spend using a correlated subquery
    SELECT
        d1.city,
        d1.transaction_date,
        (
            SELECT SUM(d2.daily_amount)
            FROM daily_spend d2
            WHERE d2.city = d1.city
              AND d2.transaction_date <= d1.transaction_date
        ) AS running_total
    FROM daily_spend d1
),
first_1500_date AS (
    -- Get the first date where cumulative spend crosses 1500 for each city
    SELECT
        city,
        MIN(transaction_date) AS date_of_1500_spend
    FROM date_of_1500
    WHERE running_total >= 1500
    GROUP BY city
)
SELECT
    f.city,
    c.first_transaction_date,
    f.date_of_1500_spend,
    (f.date_of_1500_spend - c.first_transaction_date) AS num_of_days
FROM first_1500_date f
JOIN city_first_date c ON f.city = c.city
ORDER BY f.city;
