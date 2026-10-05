-- ======================================================================
-- The Heaviest Carts
-- ======================================================================
-- Difficulty : Medium
-- Company    : DoorDash
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the-heaviest-carts
-- ======================================================================

/*
The growth team is segmenting customers by age cohort and wants to know who the biggest spenders are inside each bucket. For every age bucket, return the customer id alongside their total spend for the three customers who spent the most, from the biggest spender down.

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

Expected output ['age_bucket', 'user_id', 'total_spent']:
  [None, 585, 9568.86]
  [None, 1264, 8121.06]
  ['18-24', 682, 9757.44]
  ['18-24', 1361, 8282.699999999999]
  ['25-34', 779, 9946.02]
*/


-- Write your SQL solution below:

WITH user_spend AS (
  SELECT u.age_bucket,
         t.user_id,
         SUM(t.total_amount) AS total_spent
  FROM transactions t
  JOIN users u ON u.user_id = t.user_id
  GROUP BY u.age_bucket, t.user_id
),
ranked AS (
  SELECT age_bucket,
         user_id,
         total_spent,
         DENSE_RANK() OVER (PARTITION BY age_bucket ORDER BY total_spent DESC) AS spend_rank
  FROM user_spend
)
SELECT age_bucket, user_id, total_spent
FROM ranked
WHERE spend_rank <= 3
ORDER BY age_bucket, total_spent DESC, user_id;
