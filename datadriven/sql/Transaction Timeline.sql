-- ======================================================================
-- Transaction Timeline
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/transaction_timeline
-- ======================================================================

/*
Finance wants a one-row-per-customer purchase snapshot for the lifetime-value model. For each user with at least one transaction, find their earliest and latest transaction_date and their total spending. Return the username and those three aggregates.

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

Expected output ['username', 'first_purchase', 'latest_purchase', 'lifetime_spend']:
  ['aaron42', '2022-01-02', '2026-11-19', 8814.54]
  ['aiden', '2023-01-10', '2026-11-27', 9946.02]
  ['alice', '2026-01-05', '2026-12-05', 8605.98]
  ['amelia', '2023-02-03', '2026-12-20', 9003.12]
  ['andrew_k', '2026-02-23', '2026-12-12', 9568.86]
*/


-- Write your SQL solution below:

SELECT
    u.username,
    MIN(t.transaction_date) AS first_purchase,
    MAX(t.transaction_date) AS latest_purchase,
    ROUND(SUM(t.total_amount), 2) AS lifetime_spend
FROM users u
JOIN transactions t ON t.user_id = u.user_id
GROUP BY u.user_id, u.username
ORDER BY u.username;
