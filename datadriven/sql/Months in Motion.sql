-- ======================================================================
-- Months in Motion
-- ======================================================================
-- Difficulty : Medium
-- Company    : Whole Foods Market
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_transaction_summary
-- ======================================================================

/*
We're reading the seasonal rhythm of the business by counting engagement one calendar month at a time, across our full history and limited to transactions worth at least $5. For each month, find how many unique buyers there were and how many transactions happened in total.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['month', 'unique_users', 'total_transactions']:
  [1, 10, 17]
  [2, 10, 18]
  [3, 10, 18]
  [5, 10, 17]
  [6, 10, 16]
*/


-- Write your SQL solution below:

SELECT CAST(strftime('%m', transaction_date) AS INTEGER) AS month,
       COUNT(DISTINCT user_id) AS unique_users,
       COUNT(*) AS total_transactions
FROM transactions
WHERE total_amount >= 5
GROUP BY CAST(strftime('%m', transaction_date) AS INTEGER)
ORDER BY month
