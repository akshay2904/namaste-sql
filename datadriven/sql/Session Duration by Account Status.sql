-- ======================================================================
-- Session Duration by Account Status
-- ======================================================================
-- Difficulty : Medium
-- Company    : phData
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/session_duration_by_account_status
-- ======================================================================

/*
The product team suspects that account tier correlates with session engagement. For each account status, show the average session duration in seconds.

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

Expected output ['account_status', 'avg_session_duration']:
  ['active', 1278.0625]
  ['inactive', 1663.1707317073171]
  ['pending_verification', 1319.695652173913]
  ['suspended', 1355.3333333333333]
*/


-- Write your SQL solution below:

SELECT u.account_status, AVG(us.session_duration_sec) AS avg_session_duration
FROM users u
INNER
JOIN user_sessions us ON u.user_id = us.user_id
GROUP BY u.account_status
