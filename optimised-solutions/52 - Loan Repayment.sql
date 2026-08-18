-- ======================================================================
-- 52 - Loan Repayment
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Deloitte
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/52-loan-repayment
-- ======================================================================

/*
You're working for a large financial institution that provides various types of loans to customers. Your task is to analyze loan repayment data to assess credit risk and improve risk management strategies.

Write an SQL to create 2 flags for each loan as per below rules. Display loan id, loan amount , due date and the 2 flags.

 
1- fully_paid_flag: 1 if the loan was fully repaid irrespective of payment date else it should be 0.
2- on_time_flag : 1 if the loan was fully repaid on or before due date else 0.Table: loans
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| loan_id     | int       |
| customer_id | int       |
| loan_amount | int       |
| due_date    | date      |
+-------------+-----------+Table: payments
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| amount_paid  | int       |
| loan_id      | int       |
| payment_date | date      |
| payment_id   | int       |
+--------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH payment_summary AS (
    SELECT
        loan_id,
        SUM(amount_paid) AS total_paid,
        MAX(payment_date) AS last_payment_date  -- latest payment determines on-time status
    FROM payments
    GROUP BY loan_id
)
SELECT
    l.loan_id,
    l.loan_amount,
    l.due_date,
    -- 1 if total payments cover the full loan amount
    CASE WHEN COALESCE(ps.total_paid, 0) >= l.loan_amount THEN 1 ELSE 0 END AS fully_paid_flag,
    -- 1 if fully paid AND the last payment was on or before due date
    CASE WHEN COALESCE(ps.total_paid, 0) >= l.loan_amount
              AND ps.last_payment_date <= l.due_date THEN 1 ELSE 0 END AS on_time_flag
FROM loans l
LEFT JOIN payment_summary ps
    ON l.loan_id = ps.loan_id
ORDER BY l.loan_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    l.loan_id,
    l.loan_amount,
    l.due_date,
    -- fully_paid_flag: check if sum of all payments >= loan amount
    CASE
        WHEN (
            SELECT COALESCE(SUM(p.amount_paid), 0)
            FROM payments p
            WHERE p.loan_id = l.loan_id
        ) >= l.loan_amount THEN 1
        ELSE 0
    END AS fully_paid_flag,
    -- on_time_flag: fully paid AND latest payment date is on or before due date
    CASE
        WHEN (
            SELECT COALESCE(SUM(p.amount_paid), 0)
            FROM payments p
            WHERE p.loan_id = l.loan_id
        ) >= l.loan_amount
        AND (
            SELECT MAX(p.payment_date)
            FROM payments p
            WHERE p.loan_id = l.loan_id
        ) <= l.due_date THEN 1
        ELSE 0
    END AS on_time_flag
FROM loans l
ORDER BY l.loan_id;
