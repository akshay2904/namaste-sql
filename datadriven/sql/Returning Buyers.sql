-- ======================================================================
-- Returning Buyers
-- ======================================================================
-- Difficulty : Medium
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/returning_buyers
-- ======================================================================

/*
The retention team needs repeat-buyer signals. Find users who made a second transaction within 1 to 7 days of a previous one, excluding same-day purchases. Return each qualifying user ID once.

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

SELECT DISTINCT t1.user_id
FROM transactions t1
INNER
JOIN transactions t2 ON t1.user_id = t2.user_id AND t2.transaction_date > t1.transaction_date AND julianday(t2.transaction_date) - julianday(t1.transaction_date) BETWEEN 1 AND 7
ORDER BY t1.user_id
