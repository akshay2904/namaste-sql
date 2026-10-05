-- ======================================================================
-- Back Again
-- ======================================================================
-- Difficulty : Medium
-- Company    : Spotify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_buyers_by_transaction_count
-- ======================================================================

/*
Rank users by the number of transactions they have completed, using a dense ranking so that users with equal counts share the same rank. Return the username, transaction count, and rank for users in the top 5 tiers.

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

Expected output ['username', 'txn_count', 'rnk']:
  ['aaron42', 14, 1]
  ['aiden', 14, 1]
  ['amelia', 14, 1]
  ['alice', 12, 2]
  ['beatrice', 12, 2]
*/


-- Write your SQL solution below:

WITH user_spend AS (
  SELECT u.username,
         COUNT(t.transaction_id) AS txn_count
  FROM users u
  INNER JOIN transactions t ON u.user_id = t.user_id
  GROUP BY u.username
),
ranked AS (
  SELECT username,
         txn_count,
         DENSE_RANK() OVER (ORDER BY txn_count DESC) AS rnk
  FROM user_spend
)
SELECT username, txn_count, rnk
FROM ranked
WHERE rnk <= 5;
