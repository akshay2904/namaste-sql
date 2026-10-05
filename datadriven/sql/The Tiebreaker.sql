-- ======================================================================
-- The Tiebreaker
-- ======================================================================
-- Difficulty : Easy
-- Company    : Oracle
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/multi_column_user_sort
-- ======================================================================

/*
The admin panel needs a sortable user directory alphabetical by username, with ties broken by age bucket in reverse. Return all user profile fields.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [14359, 'abel', 'abel@example.com', '2026-10-08', 'active', '35-44']
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [585, 'andrew_k', 'andrew_k@example.com', '2024-07-07', 'suspended', None]
*/


-- Write your SQL solution below:

SELECT *
FROM users
ORDER BY username ASC, age_bucket DESC
