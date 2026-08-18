-- ======================================================================
-- The Waiting Room
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/inactive_unverified_users
-- ======================================================================

/*
We have a verification queue that's been growing. Pull all users still in 'pending_verification' status who had zero sessions during March 2026.

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

Expected output ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [2234, 'cara_z', 'cara_z@example.com', '2026-12-24', 'pending_verification', '35-44']
  [2622, 'derek', 'derek@example.com', '2024-04-28', 'pending_verification', None]
  [3010, 'dimitri', 'dimitri@example.com', '2025-08-04', 'pending_verification', '45-54']
  [3398, 'esther', 'esther@example.com', '2026-12-08', 'pending_verification', '18-24']
  [3786, 'erika_p', 'erika_p@example.com', '2024-04-12', 'pending_verification', '55-64']
*/


-- Write your SQL solution below:

SELECT u.user_id, u.username, u.email, u.signup_date,
       u.account_status, u.age_bucket
FROM users u
LEFT JOIN user_sessions us
  ON u.user_id = us.user_id
 AND strftime('%Y', us.session_start) = '2026'
 AND strftime('%m', us.session_start) = '03'
WHERE u.account_status = 'pending_verification'
  AND us.session_id IS NULL
