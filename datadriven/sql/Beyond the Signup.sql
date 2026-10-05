-- ======================================================================
-- Beyond the Signup
-- ======================================================================
-- Difficulty : Medium
-- Company    : Merilytics
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/active_users_by_session_count
-- ======================================================================

/*
The product org tracks engagement trends month over month. For the last 6 months, show the count of unique active users and the average session duration per month. Only include months where the total number of sessions exceeded 3. Present the results chronologically.

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

Expected output ['month', 'active_users', 'avg_duration_sec']:
  ['2026-07', 5, 1134]
  ['2026-08', 5, 1157]
  ['2026-09', 5, 1180]
  ['2026-10', 10, 1444.6]
  ['2026-11', 5, 1226]
*/


-- Write your SQL solution below:

SELECT strftime('%Y-%m', us.session_start) AS month,
       COUNT(DISTINCT us.user_id) AS active_users,
       AVG(us.session_duration_sec) AS avg_duration_sec
FROM user_sessions us
WHERE us.session_start >= date('2026-12-28', '-6 months')
GROUP BY month
HAVING COUNT(*) > 3
ORDER BY month
