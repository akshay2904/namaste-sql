-- ======================================================================
-- Total User Spend
-- ======================================================================
-- Difficulty : Easy
-- Company    : Etsy
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/total_user_spend
-- ======================================================================

/*
Show each user's ID, username, and total transaction amount, alphabetically by username.

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

Expected output ['user_id', 'username', 'total_spend']:
  [197, 'aaron42', 8814.54]
  [779, 'aiden', 9946.02]
  [100, 'alice', 8605.98]
  [294, 'amelia', 9003.12]
  [585, 'andrew_k', 9568.86]
*/


-- Write your SQL solution below:

SELECT u.user_id, u.username, SUM(t.total_amount) AS total_spend
FROM users u
JOIN transactions t ON u.user_id = t.user_id
GROUP BY u.user_id, u.username
ORDER BY u.username
