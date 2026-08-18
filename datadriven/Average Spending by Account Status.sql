-- ======================================================================
-- Average Spending by Account Status
-- ======================================================================
-- Difficulty : Medium
-- Company    : Rockerbox
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_spending_by_account_status
-- ======================================================================

/*
The finance team is building a lifetime value model and wants to know whether premium account tiers actually correlate with higher spend. For each account status, show the average total spend among users who have made at least one purchase.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['account_status', 'avg_total_spending']:
  ['active', 9032.38]
  ['inactive', 9060.48]
  ['pending_verification', 9429.165]
  ['suspended', 9247.32]
*/


-- Write your SQL solution below:

SELECT
  u.account_status,
  AVG(user_totals.total_spent) AS avg_total_spending
FROM users u
INNER JOIN (
  SELECT user_id, SUM(total_amount) AS total_spent
  FROM transactions
  GROUP BY user_id
) user_totals
  ON u.user_id = user_totals.user_id
GROUP BY u.account_status;
