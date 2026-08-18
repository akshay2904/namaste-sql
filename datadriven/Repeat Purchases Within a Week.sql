-- ======================================================================
-- Repeat Purchases Within a Week
-- ======================================================================
-- Difficulty : Medium
-- Company    : Vanguard
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/repeat_purchases_within_a_week
-- ======================================================================

/*
Given a table of customer transactions, identify users who made at least two purchases within a 7-day window. Return each qualifying user ID once.

Table: transactions(transaction_id, user_id, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id']:
  [197]
  [294]
  [391]
  [488]
  [585]
*/


-- Write your SQL solution below:

SELECT DISTINCT t1.user_id
FROM transactions t1
JOIN transactions t2 ON t1.user_id = t2.user_id AND t1.transaction_id < t2.transaction_id
WHERE ABS(julianday(t2.transaction_date) - julianday(t1.transaction_date)) <= 7
