-- ======================================================================
-- 5 - CIBIL Score
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Paypal
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/5-cibil-score
-- ======================================================================

/*
CIBIL score, often referred to as a credit score, is a numerical representation of an individual's credit worthiness. While the exact formula used by credit bureaus like CIBIL may not be publicly disclosed and can vary slightly between bureaus, the following are some common factors that typically influence the calculation of a credit score:

 

1- Payment History: This accounts for the largest portion of your credit score. 

It includes factors such as whether you pay your bills on time, any late payments, defaults, bankruptcies, etc.

Assume this accounts for 70 percent of your credit score.

 

2- Credit Utilization Ratio: This is the ratio of your credit card balances to your credit limits.

Keeping this ratio low (ideally below 30%) indicates responsible credit usage. 

Assume it accounts for 30% of your score and below logic to calculate it:  

Utilization below 30% = 1

Utilization between 30% and 50% = 0.7

Utilization above 50% = 0.5

Write an SQL to Calculate credit utilization ratio. Round the result to 1 decimal place.

 

Final Credit score formula = (on_time_loan_or_bill_payment)/total_bills_and_loans * 70 + Credit Utilization Ratio * 30 

Display the output in ascending order of customer id.

 
Table: customers
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| customer_id  | int       |
| credit_limit | int       |
+--------------+-----------+

Table: loans
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| customer_id   | int       |
| loan_id       | int       |
| loan_due_date | date      |
+---------------+-----------+

Table: credit_card_bills
+----------------+-----------+
| COLUMN_NAME    | DATA_TYPE |
+----------------+-----------+
| bill_amount    | int       |
| bill_due_date  | date      |
| bill_id        | int       |
| customer_id    | int       |
+----------------+-----------+

Table: customer_transactions
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| loan_bill_id     | int         |
| transaction_date | date        |
| transaction_type | varchar(10) |
+------------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH payment_history AS (
    -- Combine loans and bills, check if paid on time
    SELECT 
        l.customer_id,
        l.loan_id AS item_id,
        l.loan_due_date AS due_date,
        'loan' AS item_type
    FROM loans l
    UNION ALL
    SELECT 
        cb.customer_id,
        cb.bill_id AS item_id,
        cb.bill_due_date AS due_date,
        'bill' AS item_type
    FROM credit_card_bills cb
),
payment_status AS (
    SELECT 
        ph.customer_id,
        ph.item_id,
        ph.due_date,
        -- On time if transaction exists and transaction_date <= due_date
        CASE 
            WHEN ct.transaction_date <= ph.due_date THEN 1 
            ELSE 0 
        END AS is_on_time
    FROM payment_history ph
    LEFT JOIN customer_transactions ct 
        ON ph.item_id = ct.loan_bill_id
),
payment_score AS (
    SELECT 
        customer_id,
        SUM(is_on_time) AS on_time_payments,
        COUNT(*) AS total_payments,
        -- Payment history component: (on_time / total) * 70
        ROUND(SUM(is_on_time)::NUMERIC / NULLIF(COUNT(*), 0) * 70, 1) AS payment_history_score
    FROM payment_status
    GROUP BY customer_id
),
credit_utilization AS (
    SELECT 
        cb.customer_id,
        -- Sum of bill amounts as balance proxy, divided by credit limit
        ROUND(SUM(cb.bill_amount)::NUMERIC / NULLIF(c.credit_limit, 0), 1) AS utilization_ratio,
        -- Utilization score based on thresholds
        CASE 
            WHEN ROUND(SUM(cb.bill_amount)::NUMERIC / NULLIF(c.credit_limit, 0), 1) < 0.30 THEN 1.0
            WHEN ROUND(SUM(cb.bill_amount)::NUMERIC / NULLIF(c.credit_limit, 0), 1) <= 0.50 THEN 0.7
            ELSE 0.5
        END AS utilization_score
    FROM credit_card_bills cb
    JOIN customers c ON cb.customer_id = c.customer_id
    GROUP BY cb.customer_id, c.credit_limit
)
SELECT 
    c.customer_id,
    COALESCE(ps.on_time_payments, 0) AS on_time_payments,
    COALESCE(ps.total_payments, 0) AS total_bills_and_loans,
    COALESCE(cu.utilization_ratio, 0) AS credit_utilization_ratio,
    -- Final score = payment history score + utilization score * 30
    ROUND(
        COALESCE(ps.payment_history_score, 0) + COALESCE(cu.utilization_score, 1.0) * 30,
        1
    ) AS credit_score
FROM customers c
LEFT JOIN payment_score ps ON c.customer_id = ps.customer_id
LEFT JOIN credit_utilization cu ON c.customer_id = cu.customer_id
ORDER BY c.customer_id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    c.customer_id,
    COALESCE(pay.on_time_payments, 0) AS on_time_payments,
    COALESCE(pay.total_payments, 0) AS total_bills_and_loans,
    COALESCE(util.utilization_ratio, 0) AS credit_utilization_ratio,
    ROUND(
        -- Payment history component: (on_time / total) * 70
        COALESCE(
            (pay.on_time_payments::NUMERIC / NULLIF(pay.total_payments, 0)) * 70, 
            0
        ) 
        +
        -- Credit utilization component: utilization_score * 30
        COALESCE(
            CASE 
                WHEN util.utilization_ratio < 0.30 THEN 1.0
                WHEN util.utilization_ratio <= 0.50 THEN 0.7
                ELSE 0.5
            END * 30,
            1.0 * 30  -- default to best score if no bills
        ),
        1
    ) AS credit_score
FROM customers c
-- Subquery for payment history: join loans + bills with transactions
LEFT JOIN (
    SELECT 
        combined.customer_id,
        SUM(combined.is_on_time) AS on_time_payments,
        COUNT(*) AS total_payments
    FROM (
        -- Loans payment status
        SELECT 
            l.customer_id,
            l.loan_id AS item_id,
            l.loan_due_date AS due_date,
            CASE 
                WHEN ct.transaction_date <= l.loan_due_date THEN 1 
                ELSE 0 
            END AS is_on_time
        FROM loans l
        LEFT JOIN customer_transactions ct ON l.loan_id = ct.loan_bill_id
        UNION ALL
        -- Bills payment status
        SELECT 
            cb.customer_id,
            cb.bill_id AS item_id,
            cb.bill_due_date AS due_date,
            CASE 
                WHEN ct.transaction_date <= cb.bill_due_date THEN 1 
                ELSE 0 
            END AS is_on_time
        FROM credit_card_bills cb
        LEFT JOIN customer_transactions ct ON cb.bill_id = ct.loan_bill_id
    ) combined
    GROUP BY combined.customer_id
) pay ON c.customer_id = pay.customer_id
-- Subquery for credit utilization ratio
LEFT JOIN (
    SELECT 
        cb.customer_id,
        ROUND(SUM(cb.bill_amount)::NUMERIC / NULLIF(c2.credit_limit, 0), 1) AS utilization_ratio
    FROM credit_card_bills cb
    JOIN customers c2 ON cb.customer_id = c2.customer_id
    GROUP BY cb.customer_id, c2.credit_limit
) util ON c.customer_id = util.customer_id
ORDER BY c.customer_id ASC;
