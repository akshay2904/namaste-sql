-- ======================================================================
-- Missing Email for Non-Active Users
-- ======================================================================
-- Difficulty : Easy
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/missing_email_for_non_active_users
-- ======================================================================

/*
A downstream notification pipeline is failing for a subset of users. You traced the issue to users from 2026 who have no email on file but whose account is not active. Find those user IDs.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['user_id']:
  [1070]
  [7472]
*/


-- Write your SQL solution below:

SELECT user_id
FROM users
WHERE (email IS NULL OR email = '')
    AND account_status <> 'active'
    AND STRFTIME('%Y', signup_date) = '2026'
