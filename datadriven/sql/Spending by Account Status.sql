-- ======================================================================
-- Spending by Account Status
-- ======================================================================
-- Difficulty : Medium
-- Company    : Capital One
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/spending_by_account_status
-- ======================================================================

/*
Show each account status with its total number of transactions, the count of unique users, and the total revenue. Include users who have not made any transactions. Only show account statuses with at least 5 transactions.

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

Expected output ['account_status', 'transaction_count', 'user_count', 'total_revenue']:
  ['pending_verification', 54, 50, 37716.66]
  ['suspended', 54, 50, 36989.28]
  ['inactive', 52, 50, 36241.92]
  ['active', 40, 50, 27097.14]
*/


-- Write your SQL solution below:

SELECT u.account_status, COUNT(t.transaction_id) AS transaction_count, COUNT(DISTINCT u.user_id) AS user_count, SUM(t.total_amount) AS total_revenue
FROM users u
LEFT
JOIN transactions t ON u.user_id = t.user_id
GROUP BY u.account_status
HAVING COUNT(t.transaction_id) >= 5
ORDER BY total_revenue DESC
