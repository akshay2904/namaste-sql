-- ======================================================================
-- Even-ID June Signups
-- ======================================================================
-- Difficulty : Easy
-- Company    : Bosch
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/even_id_june_signups
-- ======================================================================

/*
The growth team is investigating a signup anomaly affecting June cohorts. Pull the full user profile for every June signup whose user ID is an even number.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']
  [1652, 'carlos', 'carlos@example.com', '2026-06-18', 'inactive', '45-54']
  [2816, 'devon', 'devon@example.com', '2026-06-02', 'inactive', '25-34']
  [3980, 'fiona', 'fiona@example.com', '2026-06-14', 'inactive', None]
  [5144, 'haruki', 'haruki@example.com', '2026-06-26', 'inactive', '55-64']
*/


-- Write your SQL solution below:

SELECT *
FROM users
WHERE strftime('%m', signup_date) = '06'
  AND user_id % 2 = 0
ORDER BY user_id
