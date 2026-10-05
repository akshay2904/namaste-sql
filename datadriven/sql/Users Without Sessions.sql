-- ======================================================================
-- Users Without Sessions
-- ======================================================================
-- Difficulty : Medium
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/users_without_sessions
-- ======================================================================

/*
Find users who have never started a session. Show the user ID, username, and email for each.

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

Expected output ['user_id', 'username', 'email']:
  [2040, 'cynthia', 'cynthia@example.com']
  [2137, 'colin42', None]
  [2234, 'cara_z', 'cara_z@example.com']
  [2428, 'celine', 'celine@example.com']
  [2525, 'daniel', 'daniel@example.com']
*/


-- Write your SQL solution below:

SELECT u.user_id, u.username, u.email
FROM users u
LEFT JOIN user_sessions s ON u.user_id = s.user_id
WHERE s.session_id IS NULL
