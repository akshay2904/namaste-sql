-- ======================================================================
-- Power Users by Session Activity
-- ======================================================================
-- Difficulty : Medium
-- Company    : eBay
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/power_users_by_session_activity
-- ======================================================================

/*
Marketing wants to feature power users in a case study. A power user is an active account holder with more than 3 sessions and over 100 total pages viewed across all of them. List each qualifying user's id, username, session count, and total pages viewed, with the heaviest users first.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id', 'username', 'session_count', 'total_pages']:
  [391, 'arjun', 5, 145]
  [1943, 'cyrus', 5, 135]
  [1555, 'brooke7', 5, 125]
  [1167, 'beatrice', 5, 115]
  [779, 'aiden', 5, 105]
*/


-- Write your SQL solution below:

SELECT
    u.user_id,
    u.username,
    COUNT(us.session_id) AS session_count,
    SUM(us.pages_viewed) AS total_pages
FROM users u
JOIN user_sessions us ON u.user_id = us.user_id
WHERE u.account_status = 'active'
GROUP BY u.user_id, u.username
HAVING COUNT(us.session_id) > 3 AND SUM(us.pages_viewed) > 100
ORDER BY total_pages DESC
