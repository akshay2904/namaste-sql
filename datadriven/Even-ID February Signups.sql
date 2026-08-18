-- ======================================================================
-- Even-ID February Signups
-- ======================================================================
-- Difficulty : Easy
-- Company    : Bosch
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/even_id_february_signups
-- ======================================================================

/*
The data quality team flagged a cohort anomaly in the signup pipeline. Pull the full user profile for every February signup whose user ID is an even number.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [1264, 'bilal', 'bilal@example.com', '2025-02-14', 'inactive', None]
  [2428, 'celine', 'celine@example.com', '2025-02-26', 'inactive', '55-64']
  [3592, 'evelyn', 'evelyn@example.com', '2025-02-10', 'inactive', '35-44']
  [4756, 'gunnar', 'gunnar@example.com', '2025-02-22', 'inactive', '18-24']
*/


-- Write your SQL solution below:

SELECT *
FROM users
WHERE strftime('%m', signup_date) = '02'
  AND user_id % 2 = 0
ORDER BY user_id
