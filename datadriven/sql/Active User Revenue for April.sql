-- ======================================================================
-- Active User Revenue for April
-- ======================================================================
-- Difficulty : Easy
-- Company    : Merilytics
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/active_user_revenue_for_april
-- ======================================================================

/*
The finance team is reconciling April 2026 revenue and needs a total that only includes transactions from users with active accounts. Revenue for a transaction is calculated as quantity multiplied by the transaction amount. Return a single total.

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

Expected output ['total_revenue']:
  [3636]
*/


-- Write your SQL solution below:

SELECT SUM(t.quantity * t.total_amount) AS total_revenue
FROM transactions t
INNER JOIN users u ON t.user_id = u.user_id
WHERE u.account_status = 'active'
  AND strftime('%Y-%m', t.transaction_date) = '2026-04'
