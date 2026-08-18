-- ======================================================================
-- Honeymoon Phase
-- ======================================================================
-- Difficulty : Medium
-- Company    : Lyft
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/same_day_signup_rate
-- ======================================================================

/*
We track customers as signup cohorts, one per registration year, to gauge how sticky each class was right after joining. For every signup year, take the transactions made by that year's cohort and report the share that landed in the same calendar year the customer registered, as a percentage rounded to two decimals.

Table: users(user_id, signup_date)

Table: transactions(transaction_id, user_id, transaction_date)

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

Expected output ['signup_year', 'same_year_pct']:
  ['2024', 10.61]
  ['2025', 10.61]
  ['2026', 60.29]
*/


-- Write your SQL solution below:

SELECT
  strftime('%Y', u.signup_date) AS signup_year,
  ROUND(100.0 * SUM(CASE WHEN strftime('%Y', t.transaction_date) = strftime('%Y', u.signup_date) THEN 1 ELSE 0 END) / COUNT(*), 2) AS same_year_pct
FROM transactions t
JOIN users u ON t.user_id = u.user_id
GROUP BY strftime('%Y', u.signup_date)
ORDER BY signup_year
