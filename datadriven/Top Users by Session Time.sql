-- ======================================================================
-- Top Users by Session Time
-- ======================================================================
-- Difficulty : Medium
-- Company    : Lyft
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_users_by_session_time
-- ======================================================================

/*
Return the top 10 users by total session duration. Show each user's ID, username, and total duration, from highest to lowest.

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

Expected output ['user_id', 'username', 'total_duration']:
  [100, 'alice', 21840]
  [1943, 'cyrus', 6935]
  [1846, 'cameron', 6820]
  [1749, 'chloe', 6705]
  [1555, 'brooke7', 6475]
*/


-- Write your SQL solution below:

SELECT u.user_id, u.username, SUM(s.session_duration_sec) AS total_duration
FROM users u
JOIN user_sessions s ON u.user_id = s.user_id
GROUP BY u.user_id, u.username
ORDER BY total_duration DESC
LIMIT 10
