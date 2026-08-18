-- ======================================================================
-- No Gaps
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/no_gaps
-- ======================================================================

/*
The email marketing team is preparing a campaign blast and needs a clean contact list with no blank fields. For each user, show their username, email address (substituting 'unknown' if the email is missing), and age bucket (substituting 'unspecified' if the age bucket is missing). Only include users whose account is currently active.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['username', 'email', 'age_bucket']:
  ['arjun', 'arjun@example.com', '55-64']
  ['aiden', 'aiden@example.com', '25-34']
  ['beatrice', 'beatrice@example.com', '65+']
  ['brooke7', 'brooke7@example.com', '35-44']
  ['cyrus', 'cyrus@example.com', 'unspecified']
*/


-- Write your SQL solution below:

SELECT
    username,
    COALESCE(email, 'unknown') AS email,
    COALESCE(age_bucket, 'unspecified') AS age_bucket
FROM users
WHERE account_status = 'active'
