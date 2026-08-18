-- ======================================================================
-- Repeat Buyers Across Halves
-- ======================================================================
-- Difficulty : Medium
-- Company    : Amazon
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/repeat_buyers_across_halves
-- ======================================================================

/*
The retention team is reviewing 2026 to find shoppers who stayed engaged the whole year instead of for just one season. Surface the users who bought something in both the first half of the year, January through June, and the second half, July through December, listed by user ID.

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

SELECT user_id
FROM transactions
WHERE CAST(strftime('%Y', transaction_date) AS INTEGER) = 2026
GROUP BY user_id
HAVING COUNT(CASE WHEN CAST(strftime('%m', transaction_date) AS INTEGER) <= 6 THEN 1 END) >= 1 AND COUNT(CASE WHEN CAST(strftime('%m', transaction_date) AS INTEGER) > 6 THEN 1 END) >= 1
ORDER BY user_id
