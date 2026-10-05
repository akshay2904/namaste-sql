-- ======================================================================
-- Purchase Log
-- ======================================================================
-- Difficulty : Easy
-- Company    : Tata Consultancy Services
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/purchase_log
-- ======================================================================

/*
The customer success team is auditing recent purchase activity and needs a human-readable transaction log. For every transaction, show the buyer's username alongside the amount spent and the date of the purchase. Only include transactions that exceed fifty dollars.

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

Expected output ['username', 'total_amount', 'transaction_date']:
  ['arjun', 50.4, '2026-04-04']
  ['ava99', 63.87, '2026-05-05']
  ['andrew_k', 77.34, '2026-06-06']
  ['anika', 90.81, '2026-07-07']
  ['aiden', 104.28, '2026-08-08']
*/


-- Write your SQL solution below:

SELECT u.username, t.total_amount, t.transaction_date
FROM users u
JOIN transactions t ON u.user_id = t.user_id
WHERE t.total_amount > 50
