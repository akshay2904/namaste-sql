-- ======================================================================
-- User Roster
-- ======================================================================
-- Difficulty : Easy
-- Company    : Tata Consultancy Services
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/user_roster
-- ======================================================================

/*
The growth team is building a retention dashboard and needs to understand the distribution of account states. For each account status, show the number of users and what share of the total user base that status represents. Round the share to one decimal place and list from largest group to smallest.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['account_status', 'user_count', 'share_pct']:
  ['suspended', 50, 25]
  ['pending_verification', 50, 25]
  ['inactive', 50, 25]
  ['active', 50, 25]
*/


-- Write your SQL solution below:

SELECT
    account_status,
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users), 1) AS share_pct
FROM users
GROUP BY account_status
ORDER BY user_count DESC
