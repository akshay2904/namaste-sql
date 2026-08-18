-- ======================================================================
-- 90 - Calculate Customer Interest
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Jp morgan
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/90-calculate-customer-interest
-- ======================================================================

/*
You are tasked with analyzing the interest earned by customers based on their account balances and transaction history. Each customer's account accrues interest based on their balance and prevailing interest rates. The interest is calculated for the ending balance on each day. Your goal is to determine the total interest earned by each customer for the month of March-2024. The interest rates (per day) are given in the interest table as per the balance amount range. 

 

Please assume that the account balance for each customer was 0 at the start of March 2024.  Write an SQL to calculate interest earned by each customer from March 1st 2024 to March 31st 2024, display the output in ascending order of customer id.

 
Table: transactions
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| transaction_id   | int       |
| customer_id      | int       |
| transaction_date | date      |
| amount           | int       |
+------------------+-----------+Table: interestrates
+---------------+--------------+
| COLUMN_NAME   | DATA_TYPE    |
+---------------+--------------+
| rate_id       | int          |
| max_balance   | int          |
| min_balance   | int          |
| interest_rate | decimal(5,4) |
+---------------+--------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH 

-- Generate all days in March 2024
march_days AS (
    SELECT generate_series('2024-03-01'::date, '2024-03-31'::date, '1 day'::interval)::date AS day
),

-- Get all customers
customers AS (
    SELECT DISTINCT customer_id FROM transactions
),

-- All customer-day combinations
customer_days AS (
    SELECT c.customer_id, md.day
    FROM customers c
    CROSS JOIN march_days md
),

-- Filter only March 2024 transactions and compute running balance per customer per day
daily_transactions AS (
    SELECT 
        customer_id,
        transaction_date,
        SUM(amount) AS daily_net  -- net amount transacted on that day
    FROM transactions
    WHERE transaction_date BETWEEN '2024-03-01' AND '2024-03-31'
    GROUP BY customer_id, transaction_date
),

-- For each customer-day, compute the running (ending) balance
-- Balance = sum of all transactions up to and including that day (starting from 0)
running_balance AS (
    SELECT 
        cd.customer_id,
        cd.day,
        COALESCE(
            SUM(dt.daily_net) OVER (
                PARTITION BY cd.customer_id 
                ORDER BY cd.day 
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ), 0
        ) AS ending_balance
    FROM customer_days cd
    LEFT JOIN daily_transactions dt
        ON cd.customer_id = dt.customer_id 
        AND cd.day = dt.transaction_date
),

-- Join with interest rates to get the applicable rate for each day's ending balance
daily_interest AS (
    SELECT 
        rb.customer_id,
        rb.day,
        rb.ending_balance,
        ir.interest_rate,
        rb.ending_balance * ir.interest_rate AS interest_earned
    FROM running_balance rb
    JOIN interestrates ir
        ON rb.ending_balance >= ir.min_balance 
        AND rb.ending_balance <= ir.max_balance
)

SELECT 
    customer_id,
    ROUND(SUM(interest_earned), 6) AS total_interest_earned
FROM daily_interest
GROUP BY customer_id
ORDER BY customer_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH 

-- Generate all days in March 2024
march_days AS (
    SELECT generate_series('2024-03-01'::date, '2024-03-31'::date, '1 day'::interval)::date AS day
),

-- Get all customers
customers AS (
    SELECT DISTINCT customer_id FROM transactions
),

-- For each customer and each day, compute ending balance
-- by summing all transactions up to and including that day
ending_balances AS (
    SELECT 
        c.customer_id,
        md.day,
        COALESCE(
            (
                SELECT SUM(t.amount)
                FROM transactions t
                WHERE t.customer_id = c.customer_id
                  AND t.transaction_date <= md.day
                  AND t.transaction_date >= '2024-03-01'  -- balance was 0 at start of March
            ), 0
        ) AS ending_balance
    FROM customers c
    CROSS JOIN march_days md
),

-- For each customer-day, find the applicable interest rate
daily_interest AS (
    SELECT 
        eb.customer_id,
        eb.day,
        eb.ending_balance,
        (
            SELECT ir.interest_rate
            FROM interestrates ir
            WHERE eb.ending_balance >= ir.min_balance
              AND eb.ending_balance <= ir.max_balance
            LIMIT 1
        ) AS interest_rate,
        eb.ending_balance * (
            SELECT ir.interest_rate
            FROM interestrates ir
            WHERE eb.ending_balance >= ir.min_balance
              AND eb.ending_balance <= ir.max_balance
            LIMIT 1
        ) AS interest_earned
    FROM ending_balances eb
)

SELECT 
    customer_id,
    ROUND(SUM(interest_earned), 6) AS total_interest_earned
FROM daily_interest
GROUP BY customer_id
ORDER BY customer_id;
