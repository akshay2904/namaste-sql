-- ======================================================================
-- Cheapest Transaction per User
-- ======================================================================
-- Difficulty : Easy
-- Company    : Shopify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cheapest_transaction_per_user
-- ======================================================================

/*
The pricing team is looking at each user's lowest-value purchase to understand the floor of what people are willing to spend. Show the user ID, username, and their smallest transaction amount, from the lowest up.

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

Expected output ['user_id', 'username', 'min_amount']:
  [197, 'aaron42', 23.46]
  [294, 'amelia', 36.93]
  [391, 'arjun', 50.4]
  [488, 'ava99', 63.87]
  [585, 'andrew_k', 77.34]
*/


-- Write your SQL solution below:

SELECT u.user_id, u.username, MIN(t.total_amount) AS min_amount
FROM users u
JOIN transactions t ON u.user_id = t.user_id
GROUP BY u.user_id, u.username
ORDER BY min_amount ASC
