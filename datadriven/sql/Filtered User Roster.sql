-- ======================================================================
-- Filtered User Roster
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/filtered_user_roster
-- ======================================================================

/*
The growth team is assembling a clean outreach roster and wants the 'admin' and 'system' accounts left out, along with anyone whose email carries a 'z' anywhere (a known test-account marker). Keep every other user, including those who have no email on record yet, and return each remaining profile in full, alphabetical by username.

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
WHERE username NOT IN ('admin', 'system')
  AND (email NOT LIKE '%z%' OR email IS NULL)
ORDER BY username
