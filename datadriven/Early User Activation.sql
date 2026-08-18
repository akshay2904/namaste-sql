-- ======================================================================
-- Early User Activation
-- ======================================================================
-- Difficulty : Medium
-- Company    : Dropbox
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/early_user_activation
-- ======================================================================

/*
We want to see which users activated early. Surface users who recorded at least one session within 365 days of signing up, showing user ID, signup date, and session count in that window. Users with zero sessions in their first year should not appear.

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

Expected output ['user_id', 'signup_date', 'session_count']:
  [100, '2025-02-02', 1]
  [197, '2026-03-03', 3]
  [391, '2025-05-05', 2]
  [682, '2025-08-08', 4]
  [973, '2025-11-11', 5]
*/


-- Write your SQL solution below:

SELECT u.user_id, u.signup_date, COUNT(*) AS session_count
FROM users u
INNER JOIN user_sessions us ON u.user_id = us.user_id
WHERE julianday(us.session_start) - julianday(u.signup_date) BETWEEN 0 AND 365
GROUP BY u.user_id, u.signup_date
HAVING session_count >= 1
ORDER BY u.user_id
