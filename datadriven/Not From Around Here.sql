-- ======================================================================
-- Not From Around Here
-- ======================================================================
-- Difficulty : Easy
-- Company    : PwC
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/filter_by_domain
-- ======================================================================

/*
The security team flagged sign-ups on the '@example.com' domain after a burst of suspicious activity. Pull every user whose email address sits on that domain, returning their user_id, username, and full email.

Table: users(user_id, username, email)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['user_id', 'username', 'email']:
  [100, 'alice', 'alice@example.com']
  [197, 'aaron42', 'aaron42@example.com']
  [294, 'amelia', 'amelia@example.com']
  [391, 'arjun', 'arjun@example.com']
  [488, 'ava99', 'ava99@example.com']
*/


-- Write your SQL solution below:

SELECT user_id, username, email
FROM users
WHERE email LIKE '%@example.com'
ORDER BY user_id
