-- ======================================================================
-- Session Count Distribution
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/session_count_distribution
-- ======================================================================

/*
For users who signed up between 2024 and 2026, count how many sessions each had in February 2026, then show the session count and how many users had that exact count, from fewest sessions to most.

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

Expected output ['session_count', 'user_count']:
  [1, 5]
  [2, 6]
*/


-- Write your SQL solution below:

WITH qualifying_users AS (
    SELECT user_id FROM users
    WHERE signup_date BETWEEN '2024-01-01' AND '2026-12-31'
),
feb_sessions AS (
    SELECT us.user_id, COUNT(*) AS session_count
    FROM user_sessions us
    INNER JOIN qualifying_users qu ON us.user_id = qu.user_id
    WHERE strftime('%Y-%m', us.session_start) = '2026-02'
    GROUP BY us.user_id
)
SELECT session_count, COUNT(*) AS user_count
FROM feb_sessions
GROUP BY session_count
ORDER BY session_count ASC
