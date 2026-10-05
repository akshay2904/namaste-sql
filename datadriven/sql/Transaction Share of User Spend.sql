-- ======================================================================
-- Transaction Share of User Spend
-- ======================================================================
-- Difficulty : Medium
-- Company    : Etsy
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/transaction_share_of_user_spend
-- ======================================================================

/*
For each transaction, show the transaction ID, username, the transaction amount, and the ratio of that transaction's amount to the user's overall total as a decimal. Each username is unique and each user has at most one transaction per day.

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

Expected output ['transaction_id', 'username', 'total_amount', 'spend_share']:
  [1067, 'aaron42', 23.46, 0.0026615115479650666]
  [2072, 'aaron42', 225.51, 0.025583864841500516]
  [3077, 'aaron42', 427.56, 0.04850621813503597]
  [4082, 'aaron42', 629.61, 0.07142857142857142]
  [5087, 'aaron42', 831.66, 0.09435092472210686]
*/


-- Write your SQL solution below:

SELECT
    t.transaction_id,
    u.username,
    t.total_amount,
    t.total_amount * 1.0 / SUM(t.total_amount) OVER (PARTITION BY t.user_id) AS spend_share
FROM transactions t
JOIN users u ON t.user_id = u.user_id
ORDER BY u.username, t.transaction_id
