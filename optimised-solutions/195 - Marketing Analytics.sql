-- ======================================================================
-- 195 - Marketing Analytics
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Hackerrank
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/195-marketing-analytics
-- ======================================================================

/*
As part of NamasteMart's e-commerce marketing analytics, the team needs to generate a July 2021 customer revenue summary report. Revenue from a customer is the sum of the values described below.

type=BUY, the customer purchased something, the transaction amount is potential revenue
type=SELL, the customer sold something, HackerMart collects a fee, 10% of the transaction amount is potential revenue
 

Status determines how a transaction is treated.

status = COMPLETED, the transaction is included
status = PENDING, the transaction is ignored
status = CANCELED, the transaction is void, 1% of the transaction amount is deducted from total revenue
 

Columns to report are customer, buy, sell, completed, pending, canceled, total. 
buy, sell, completed, pending, and canceled are the number of transactions that match, and total is the total revenue, calculated as described and rounded to 2 places after the decimal. Sort the result in descending order of total revenue.

 
Table: transactions
+-------------+---------------+
| COLUMN_NAME | DATA_TYPE     |
+-------------+---------------+
| dt          | VARCHAR(19)   |
| customer    | VARCHAR(30)   |
| type        | VARCHAR(4)    |
| amount      | DECIMAL(4,2)  |
| status      | VARCHAR(9)    |
+-------------+---------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH july_txns AS (
    SELECT
        customer,
        type,
        amount,
        status
    FROM transactions
    WHERE dt >= '2021-07-01'
      AND dt <  '2021-08-01'
),
summary AS (
    SELECT
        customer,
        -- Count of BUY and SELL transactions (all statuses)
        COUNT(*) FILTER (WHERE type = 'BUY')                          AS buy,
        COUNT(*) FILTER (WHERE type = 'SELL')                         AS sell,
        -- Count by status (all types)
        COUNT(*) FILTER (WHERE status = 'COMPLETED')                  AS completed,
        COUNT(*) FILTER (WHERE status = 'PENDING')                    AS pending,
        COUNT(*) FILTER (WHERE status = 'CANCELED')                   AS canceled,
        -- Revenue calculation:
        -- COMPLETED BUY  => full amount
        -- COMPLETED SELL => 10% of amount
        -- CANCELED       => -1% of amount (regardless of type)
        -- PENDING        => ignored
        ROUND(
            COALESCE(SUM(amount)       FILTER (WHERE type = 'BUY'  AND status = 'COMPLETED'), 0)
          + COALESCE(SUM(amount * 0.1) FILTER (WHERE type = 'SELL' AND status = 'COMPLETED'), 0)
          - COALESCE(SUM(amount * 0.01)FILTER (WHERE status = 'CANCELED'), 0)
        , 2)                                                           AS total
    FROM july_txns
    GROUP BY customer
)
SELECT
    customer,
    buy,
    sell,
    completed,
    pending,
    canceled,
    total
FROM summary
ORDER BY total DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    customer,
    SUM(CASE WHEN type = 'BUY'  THEN 1 ELSE 0 END)                        AS buy,
    SUM(CASE WHEN type = 'SELL' THEN 1 ELSE 0 END)                         AS sell,
    SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END)                  AS completed,
    SUM(CASE WHEN status = 'PENDING'   THEN 1 ELSE 0 END)                  AS pending,
    SUM(CASE WHEN status = 'CANCELED'  THEN 1 ELSE 0 END)                  AS canceled,
    ROUND(
        -- COMPLETED BUY: full amount
        SUM(CASE WHEN type = 'BUY'  AND status = 'COMPLETED' THEN amount       ELSE 0 END)
        -- COMPLETED SELL: 10% fee collected
      + SUM(CASE WHEN type = 'SELL' AND status = 'COMPLETED' THEN amount * 0.1 ELSE 0 END)
        -- CANCELED any type: deduct 1% of amount
      - SUM(CASE WHEN status = 'CANCELED'                    THEN amount * 0.01 ELSE 0 END)
    , 2)                                                                    AS total
FROM transactions
WHERE dt >= '2021-07-01'
  AND dt <  '2021-08-01'
GROUP BY customer
ORDER BY total DESC;
