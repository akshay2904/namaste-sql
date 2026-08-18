-- ======================================================================
-- 198 - Customer Revenue Report
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Hackerrank
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/198-customer-revenue-report
-- ======================================================================

/*
As part of NamasteMart's e-commerce marketing analytics, they need a revenue report for their customers in July, 2021. Revenue from a customer is the sum of the values described below.

type=BUY, the customer purchased something, the transaction amount is potential revenue
type=SELL, the customer sold something, NamasteMart collects a fee, 10% of the transaction amount is potential revenue

Status determines how a transaction is treated.

status = COMPLETED, the transaction is included
status = PENDING, the transaction is ignored
status = CANCELED, the transaction is void, 1% of the transaction amount is deducted from revenue

Requirements:

Columns to report are customer, buy, sell, total.
buy, and sell are revenues for buy and sell transactions, respectively.
total is the sum of buy and sell.
Round to 2 places after the decimal.
Order the records descending by total.

 
Table: transactions
+--------------+--------------+----------------------------------+
| COLUMN_NAME  | DATA_TYPE    | DESCRIPTION                      |
+--------------+--------------+----------------------------------+
| dt           | VARCHAR(19)  | Transaction timestamp            |
| customer     | VARCHAR(64)  | Customer email address           |
| type         | VARCHAR(4)   | Transaction type                 |
| amount       | DECIMAL(4,2) | Transaction amount               |
| status       | VARCHAR(9)   | Transaction status               |
+--------------+--------------+----------------------------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH july_transactions AS (
    SELECT
        customer,
        type,
        amount,
        status,
        -- Calculate the effective revenue contribution per transaction in one pass
        CASE
            WHEN type = 'BUY' AND status = 'COMPLETED'  THEN amount
            WHEN type = 'BUY' AND status = 'CANCELED'   THEN -0.01 * amount
            WHEN type = 'SELL' AND status = 'COMPLETED' THEN 0.10 * amount
            WHEN type = 'SELL' AND status = 'CANCELED'  THEN -0.01 * amount
            ELSE 0  -- PENDING transactions are ignored
        END AS revenue_contribution
    FROM transactions
    WHERE dt >= '2021-07-01'
      AND dt  < '2021-08-01'
      AND type IN ('BUY', 'SELL')
)
SELECT
    customer,
    ROUND(SUM(CASE WHEN type = 'BUY'  THEN revenue_contribution ELSE 0 END), 2) AS buy,
    ROUND(SUM(CASE WHEN type = 'SELL' THEN revenue_contribution ELSE 0 END), 2) AS sell,
    ROUND(SUM(revenue_contribution), 2) AS total
FROM july_transactions
GROUP BY customer
ORDER BY total DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    customer,
    ROUND(
        COALESCE((
            SELECT SUM(
                CASE
                    WHEN status = 'COMPLETED' THEN amount
                    WHEN status = 'CANCELED'  THEN -0.01 * amount
                    ELSE 0
                END
            )
            FROM transactions t2
            WHERE t2.customer = t1.customer
              AND t2.type = 'BUY'
              AND t2.dt >= '2021-07-01'
              AND t2.dt  < '2021-08-01'
        ), 0)
    , 2) AS buy,
    ROUND(
        COALESCE((
            SELECT SUM(
                CASE
                    WHEN status = 'COMPLETED' THEN 0.10 * amount
                    WHEN status = 'CANCELED'  THEN -0.01 * amount
                    ELSE 0
                END
            )
            FROM transactions t3
            WHERE t3.customer = t1.customer
              AND t3.type = 'SELL'
              AND t3.dt >= '2021-07-01'
              AND t3.dt  < '2021-08-01'
        ), 0)
    , 2) AS sell,
    ROUND(
        COALESCE((
            SELECT SUM(
                CASE
                    WHEN status = 'COMPLETED' THEN amount
                    WHEN status = 'CANCELED'  THEN -0.01 * amount
                    ELSE 0
                END
            )
            FROM transactions t4
            WHERE t4.customer = t1.customer
              AND t4.type = 'BUY'
              AND t4.dt >= '2021-07-01'
              AND t4.dt  < '2021-08-01'
        ), 0)
        +
        COALESCE((
            SELECT SUM(
                CASE
                    WHEN status = 'COMPLETED' THEN 0.10 * amount
                    WHEN status = 'CANCELED'  THEN -0.01 * amount
                    ELSE 0
                END
            )
            FROM transactions t5
            WHERE t5.customer = t1.customer
              AND t5.type = 'SELL'
              AND t5.dt >= '2021-07-01'
              AND t5.dt  < '2021-08-01'
        ), 0)
    , 2) AS total
FROM transactions t1
WHERE t1.dt >= '2021-07-01'
  AND t1.dt  < '2021-08-01'
GROUP BY customer
ORDER BY total DESC;
