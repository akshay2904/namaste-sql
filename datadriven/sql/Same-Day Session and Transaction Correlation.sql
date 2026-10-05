-- ======================================================================
-- Same-Day Session and Transaction Correlation
-- ======================================================================
-- Difficulty : Hard
-- Company    : Walmart
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/same_day_session_and_transaction_correlation
-- ======================================================================

/*
Find users who started a session and placed a transaction on the same calendar day. For those users, show user ID, the date, total transactions, and total transaction amount for that day.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'the_date', 'total_transactions', 'total_amount']:
  [100, '2026-01-05', 1, 818.19]
  [197, '2026-02-02', 1, 23.46]
  [197, '2026-02-06', 1, 831.66]
  [294, '2026-03-03', 1, 36.93]
  [294, '2026-03-07', 1, 845.13]
*/


-- Write your SQL solution below:

SELECT t.user_id, date(t.transaction_date) AS the_date, COUNT(DISTINCT t.transaction_id) AS total_transactions, SUM(t.total_amount) AS total_amount
FROM transactions t
INNER
JOIN user_sessions us ON t.user_id = us.user_id AND date(t.transaction_date) = date(us.session_start)
GROUP BY t.user_id, date(t.transaction_date)
ORDER BY t.user_id, the_date
