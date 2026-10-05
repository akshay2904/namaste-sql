-- ======================================================================
-- Two Names on the Ledger
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/revenue_for_specific_users
-- ======================================================================

/*
Finance is reconciling revenue for two customers, alice and aaron42, and wants to see how their spend stacks up across both accounts, one transaction at a time. From the earliest transaction ID to the latest, return each transaction's ID, the customer, its amount, and the combined revenue accumulated through it.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['transaction_id', 'username', 'total_amount', 'running_total']:
  [1067, 'aaron42', 23.46, 23.46]
  [2005, 'alice', 212.04, 235.5]
  [2072, 'aaron42', 225.51, 461.01]
  [3010, 'alice', 414.09, 875.0999999999999]
  [3077, 'aaron42', 427.56, 1302.6599999999999]
*/


-- Write your SQL solution below:

SELECT t.transaction_id,
       u.username,
       t.total_amount,
       SUM(t.total_amount) OVER (ORDER BY t.transaction_id) AS running_total
FROM transactions t
INNER JOIN users u ON t.user_id = u.user_id
WHERE u.username IN ('alice', 'aaron42')
ORDER BY t.transaction_id
