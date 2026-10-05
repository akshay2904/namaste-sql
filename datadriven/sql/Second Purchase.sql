-- ======================================================================
-- Second Purchase
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/second_purchase
-- ======================================================================

/*
The onboarding team wants to study second-purchase behavior. For each user with more than one transaction, order their transactions by transaction_date and isolate the second one. Return the user_id, total_amount, and transaction_date of that second purchase.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'total_amount', 'transaction_date']:
  [100, 212.04, '2026-03-16']
  [197, 831.66, '2022-01-06']
  [294, 845.13, '2023-02-07']
  [391, 858.6, '2024-03-08']
  [488, 63.87, '2025-04-05']
*/


-- Write your SQL solution below:

WITH numbered AS (
    SELECT user_id, total_amount, transaction_date, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS rn
    FROM transactions
)
SELECT user_id, total_amount, transaction_date
FROM numbered
WHERE rn = 2
