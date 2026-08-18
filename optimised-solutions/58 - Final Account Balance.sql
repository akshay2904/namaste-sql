-- ======================================================================
-- 58 - Final Account Balance
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Deloitte
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/58-final-account-balance
-- ======================================================================

/*
You are given history of your bank account for the year 2020. Each transaction is either a credit card payment or incoming transfer. There is a fee of holding a credit card which you have to pay every month, Fee is 5 per month. However, you are not charged for a given month if you made at least 2 credit card payments for a total cost of at least 100 within that month. Note that this fee is not included in the supplied history of transactions.
Each row in the table contains information about a single transaction. If the amount value is negative, it is a credit card payment otherwise it is an incoming transfer. At the beginning of the year, the balance of your account was 0 . Your task is to compute the balance at the end of the year. 

 

Table : Transactions 
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| amount           | int       |
| transaction_date | date      |
+------------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_stats AS (
    -- Compute per-month: count of credit card payments and their total absolute value
    SELECT
        EXTRACT(MONTH FROM transaction_date) AS month,
        COUNT(*) FILTER (WHERE amount < 0)          AS cc_payment_count,
        ABS(SUM(amount) FILTER (WHERE amount < 0))  AS cc_payment_total
    FROM Transactions
    GROUP BY EXTRACT(MONTH FROM transaction_date)
),
months AS (
    -- All 12 months of 2020
    SELECT generate_series(1, 12) AS month
),
fee_per_month AS (
    -- Fee is 5 unless at least 2 payments totaling >= 100 were made that month
    SELECT
        m.month,
        CASE
            WHEN COALESCE(ms.cc_payment_count, 0) >= 2
             AND COALESCE(ms.cc_payment_total, 0) >= 100
            THEN 0
            ELSE 5
        END AS fee
    FROM months m
    LEFT JOIN monthly_stats ms ON m.month = ms.month
),
total_fee AS (
    SELECT SUM(fee) AS fees FROM fee_per_month
),
total_transactions AS (
    SELECT COALESCE(SUM(amount), 0) AS net FROM Transactions
)
SELECT
    tt.net - tf.fees AS balance
FROM total_transactions tt, total_fee tf;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    -- Sum of all transactions minus total fees accumulated
    (SELECT COALESCE(SUM(amount), 0) FROM Transactions)
    -
    -- Count the months where fee applies (12 total minus exempt months) * 5
    (
        12 - (
            -- Count months that are exempt from the fee
            SELECT COUNT(*)
            FROM (
                SELECT
                    EXTRACT(MONTH FROM transaction_date) AS month
                FROM Transactions
                WHERE amount < 0
                GROUP BY EXTRACT(MONTH FROM transaction_date)
                HAVING COUNT(*) >= 2
                   AND SUM(ABS(amount)) >= 100
            ) AS exempt_months
        )
    ) * 5 AS balance;
