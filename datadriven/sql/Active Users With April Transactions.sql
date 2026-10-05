-- ======================================================================
-- Active Users With April Transactions
-- ======================================================================
-- Difficulty : Easy
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/active_users_with_april_transactions
-- ======================================================================

/*
The growth team is measuring transacting reach for April 2026. How many users with active accounts completed at least one transaction during that month? Return a single count.

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

Expected output ['active_users_with_transactions']:
  [1]
*/


-- Write your SQL solution below:

SELECT COUNT(DISTINCT u.user_id) AS active_users_with_transactions
FROM users u
JOIN transactions t ON u.user_id = t.user_id
WHERE u.account_status = 'active'
  AND strftime('%Y', t.transaction_date) = '2026'
  AND strftime('%m', t.transaction_date) = '04'
