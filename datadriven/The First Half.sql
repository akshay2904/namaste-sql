-- ======================================================================
-- The First Half
-- ======================================================================
-- Difficulty : Easy
-- Company    : Maana
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_first_half
-- ======================================================================

/*
The growth team is measuring first-half cohort size for 2026. How many users signed up between January 1 and July 31 inclusive?

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['signup_count']:
  [34]
*/


-- Write your SQL solution below:

SELECT COUNT(*) AS signup_count
FROM users
WHERE signup_date >= '2026-01-01'
  AND signup_date <  '2026-08-01'
