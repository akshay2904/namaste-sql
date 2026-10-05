-- ======================================================================
-- The Subscription Ghost
-- ======================================================================
-- Difficulty : Medium
-- Company    : PayPal
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/repeated_transactions
-- ======================================================================

/*
A billing-integrity team is chasing accidental recurring charges: a customer billed the same amount for the same product about a month after the last time, usually a duplicate subscription or a botched retry. Within each user and product pairing, compare every charge to the one immediately before it in time, and surface the charges that repeat the previous amount exactly and land 35 days or fewer after it.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['transaction_id', 'user_id', 'product_id', 'total_amount', 'transaction_date']:
  [6628, 973, 5068, 1141.47, '2026-01-01']
  [2608, 973, 2128, 333.27, '2026-01-25']
  [6695, 1070, 5117, 1154.94, '2026-02-02']
  [4350, 585, 3402, 683.49, '2026-03-23']
  [2005, 100, 1687, 212.04, '2026-04-16']
*/


-- Write your SQL solution below:

WITH lagged AS (
    SELECT *, LAG(total_amount) OVER (PARTITION BY user_id, product_id ORDER BY transaction_date) AS prev_amount, LAG(transaction_date) OVER (PARTITION BY user_id, product_id ORDER BY transaction_date) AS prev_date
    FROM transactions
)
SELECT transaction_id, user_id, product_id, total_amount, transaction_date
FROM lagged
WHERE total_amount = prev_amount AND (julianday(transaction_date) - julianday(prev_date)) <= 35
ORDER BY transaction_date
