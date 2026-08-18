-- ======================================================================
-- Email Census
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/email_census
-- ======================================================================

/*
The CRM team is sizing their outreach lists before the next campaign. Segment every user account into one of two groups: those with an email address on file and those without. For each segment, show how many users fall into each bucket and what share of all users that segment represents, expressed as a percentage rounded to one decimal place. List the larger segment first.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['email_status', 'user_count', 'pct']:
  ['has email', 184, 92]
  ['no email', 16, 8]
*/


-- Write your SQL solution below:

SELECT CASE WHEN email IS NULL THEN 'no email' ELSE 'has email' END AS email_status, COUNT(*) AS user_count, ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users), 1) AS pct FROM users GROUP BY email_status ORDER BY user_count DESC
