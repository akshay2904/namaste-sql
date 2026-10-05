-- ======================================================================
-- Mentorship User Pairs
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/mentorship_user_pairs
-- ======================================================================

/*
We're setting up an internal mentorship program. Find all pairs of users who have different age brackets, the same account status, and signed up in different years. Each pair should appear only once, with the smaller user ID first. Show both user IDs.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['user_id_1', 'user_id_2']:
  [100, 16396]
  [100, 17560]
  [197, 12613]
  [294, 14262]
  [391, 8151]
*/


-- Write your SQL solution below:

SELECT u1.user_id AS user_id_1, u2.user_id AS user_id_2
FROM users u1
JOIN users u2 ON u1.user_id < u2.user_id
WHERE u1.age_bucket <> u2.age_bucket
    AND u1.account_status = u2.account_status
    AND STRFTIME('%Y', u1.signup_date) <> STRFTIME('%Y', u2.signup_date)
