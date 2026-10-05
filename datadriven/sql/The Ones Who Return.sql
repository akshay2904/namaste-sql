-- ======================================================================
-- The Ones Who Return
-- ======================================================================
-- Difficulty : Medium
-- Company    : CVS Health
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the-ones-who-return
-- ======================================================================

/*
Our member growth team suspects that a large share of the people who buy from us try the service exactly once and never come back, while a smaller core keeps returning again and again, and before the quarterly retention review they want one anchor number to ground that story. Using the complete purchase history, work out what share of the entire member base counts as repeat buyers, meaning any member who shows up with more than a single purchase to their name, and express that share as a percentage of all members rounded to two decimal places.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['repeat_member_pct']:
  [100]
*/


-- Write your SQL solution below:

WITH member_activity AS (
  SELECT user_id, COUNT(*) AS txn_count
  FROM transactions
  GROUP BY user_id
)
SELECT ROUND(100.0 * SUM(CASE WHEN txn_count >= 2 THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_member_pct
FROM member_activity;
