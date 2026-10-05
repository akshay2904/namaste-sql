-- ======================================================================
-- What's in a Name
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/initial_count
-- ======================================================================

/*
The support team noticed certain username patterns correlate with ticket volume and wants to verify a hunch. For each first letter of the username, show how many users share that initial and what percentage of the total user base they represent. Round the percentage to one decimal place and show the most common initials first.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['initial', 'user_count', 'pct']:
  ['a', 16, 8]
  ['m', 14, 7]
  ['c', 13, 6.5]
  ['s', 12, 6]
  ['j', 12, 6]
*/


-- Write your SQL solution below:

SELECT
    SUBSTR(username, 1, 1) AS initial,
    COUNT(*) AS user_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM users), 1) AS pct
FROM users
GROUP BY SUBSTR(username, 1, 1)
ORDER BY user_count DESC
