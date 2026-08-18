-- ======================================================================
-- February 2024 Signups
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/february_signups
-- ======================================================================

/*
The lifecycle marketing team is rebuilding a campaign for users who joined in February of 2024. Pull every column for every user whose signup falls in that month.

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
WHERE strftime('%Y-%m', signup_date) = '2025-02';
