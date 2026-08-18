-- ======================================================================
-- Spend and Rank
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/spend_and_rank
-- ======================================================================

/*
The executive team wants a leaderboard of the 5 biggest spenders for the quarterly review. Sum spending per user, assign positions starting at 1 for the biggest spender with ties sharing a position, and keep only users in the top 5 positions. Return the username, total spend, and position.

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

Expected output ['username', 'total', 'rnk']:
  ['bjorn99', 10511.76, 1]
  ['brian', 10323.18, 2]
  ['aria_b', 10134.6, 3]
  ['aiden', 9946.02, 4]
  ['anika', 9757.44, 5]
*/


-- Write your SQL solution below:

WITH ranked AS (
    SELECT u.username, SUM(t.total_amount) AS total, RANK() OVER (ORDER BY SUM(t.total_amount) DESC) AS rnk
    FROM users u
    JOIN transactions t ON u.user_id = t.user_id
    GROUP BY u.username
)
SELECT username, total, rnk
FROM ranked
WHERE rnk <= 5
