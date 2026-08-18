-- ======================================================================
-- Transaction Overview
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/transaction_overview
-- ======================================================================

/*
The finance team needs two numbers for the board slide: how many users have made at least one purchase, and the average transaction amount across all transactions.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['unique_purchasers', 'avg_transaction_amount']:
  [15, 690.225]
*/


-- Write your SQL solution below:

SELECT
    COUNT(DISTINCT user_id) AS unique_purchasers,
    AVG(total_amount) AS avg_transaction_amount
FROM transactions
