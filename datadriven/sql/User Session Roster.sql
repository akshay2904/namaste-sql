-- ======================================================================
-- User Session Roster
-- ======================================================================
-- Difficulty : Easy
-- Company    : Ripple
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/user_session_roster
-- ======================================================================

/*
Produce a complete user-to-session roster that includes users who have never started a session. Show each user's name, account status, signup date, and session start time, by username and then session start.

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

Expected output ['username', 'account_status', 'signup_date', 'session_start']:
  ['aaron42', 'suspended', '2026-03-03', '2026-02-02 01:00:00']
  ['aaron42', 'suspended', '2026-03-03', '2026-02-06 13:00:00']
  ['abel', 'active', '2026-10-08', None]
  ['alice', 'inactive', '2025-02-02', '2026-01-05 12:00:00']
  ['amelia', 'pending_verification', '2024-04-04', '2026-03-03 02:00:00']
*/


-- Write your SQL solution below:

SELECT u.username, u.account_status, u.signup_date, s.session_start
FROM users u
LEFT JOIN user_sessions s ON u.user_id = s.user_id
ORDER BY u.username, s.session_start
