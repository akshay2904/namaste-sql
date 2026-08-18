-- ======================================================================
-- The Spending Rhythm
-- ======================================================================
-- Difficulty : Easy
-- Company    : Merilytics
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_transaction_counts
-- ======================================================================

/*
A monthly spending cadence report needs each user's transaction count broken out by calendar month so the finance team can spot irregular purchasing patterns. Order results by user then month.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'month', 'transaction_count']:
  [100, '2026-01', 1]
  [100, '2026-03', 2]
  [100, '2026-04', 2]
  [100, '2026-09', 1]
  [100, '2026-10', 1]
*/


-- Write your SQL solution below:

SELECT user_id,
    STRFTIME('%Y-%m', transaction_date) AS month,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY user_id, STRFTIME('%Y-%m', transaction_date)
ORDER BY user_id, month
