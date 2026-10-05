-- ======================================================================
-- Inactive Users in Date Range
-- ======================================================================
-- Difficulty : Medium
-- Company    : Instacart
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/inactive_users_in_date_range
-- ======================================================================

/*
The data quality team flagged stale records in a dimension table. Identify users who had zero sessions between June 1 and July 1, 2026. Include both users who were active outside that window and users who never had any sessions at all.

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

Expected output ['username']:
  ['abel']
  ['aiden']
  ['amelia']
  ['andre']
  ['anika']
*/


-- Write your SQL solution below:

SELECT u.username
FROM users u
LEFT JOIN user_sessions us
  ON u.user_id = us.user_id
  AND us.session_start >= '2026-06-01'
  AND us.session_start < '2026-07-02'
WHERE us.session_id IS NULL
ORDER BY u.username
