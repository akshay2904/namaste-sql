-- ======================================================================
-- Spending Range
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/spending_range
-- ======================================================================

/*
Data science is modeling per-user spending variability and only cares about customers who have made more than one purchase. For each of those users, return the username, their smallest and largest transaction amount, and the gap between the two, sorted from the widest gap to the narrowest.

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

Expected output ['username', 'low', 'high', 'high - low']:
  ['ava99', 63.87, 1276.17, 1212.3000000000002]
  ['aaron42', 23.46, 1235.76, 1212.3]
  ['beatrice', 158.16, 1168.41, 1010.2500000000001]
  ['alice', 212.04, 1222.29, 1010.25]
  ['bella_q', 185.1, 1195.35, 1010.2499999999999]
*/


-- Write your SQL solution below:

WITH user_range AS (
    SELECT u.user_id, u.username, MIN(t.total_amount) AS low, MAX(t.total_amount) AS high
    FROM users u
    JOIN transactions t ON u.user_id = t.user_id
    GROUP BY u.user_id, u.username
)
SELECT username, low, high, high - low
FROM user_range ur
WHERE (SELECT COUNT(*) FROM transactions t WHERE t.user_id = ur.user_id) > 1
ORDER BY high - low DESC
