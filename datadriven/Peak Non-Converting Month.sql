-- ======================================================================
-- Peak Non-Converting Month
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/peak_non_converting_month
-- ======================================================================

/*
Which month in 2026 had the most users who had sessions but never made a purchase? Show the month and the count of non-converting users.

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

Expected output ['session_month', 'non_converting_users']:
  ['2026-02', 7]
*/


-- Write your SQL solution below:

SELECT strftime('%Y-%m', us.session_start) AS session_month, COUNT(DISTINCT us.user_id) AS non_converting_users FROM user_sessions us WHERE strftime('%Y', us.session_start) = '2026' AND us.user_id NOT IN (SELECT DISTINCT user_id FROM transactions WHERE user_id IS NOT NULL) GROUP BY session_month ORDER BY non_converting_users DESC, session_month ASC LIMIT 1
