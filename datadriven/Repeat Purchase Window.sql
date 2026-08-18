-- ======================================================================
-- Repeat Purchase Window
-- ======================================================================
-- Difficulty : Medium
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/repeat_purchase_window
-- ======================================================================

/*
A churn model needs repeat-purchase signals. Find users who made another purchase within 1 to 7 days of a previous transaction, excluding same-day transactions. Return each qualifying user ID once.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id']:
  [100]
  [197]
  [294]
  [391]
  [488]
*/


-- Write your SQL solution below:

SELECT DISTINCT user_id
FROM ( SELECT user_id, transaction_date, LAG(transaction_date) OVER (PARTITION BY user_id ORDER BY transaction_date) AS prev_date FROM transactions )
WHERE julianday(transaction_date) - julianday(prev_date) BETWEEN 1 AND 7
