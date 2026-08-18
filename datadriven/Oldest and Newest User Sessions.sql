-- ======================================================================
-- Oldest and Newest User Sessions
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/oldest_and_newest_user_sessions
-- ======================================================================

/*
The growth team wants to compare engagement between the very first person to sign up and the most recent one, looking only at people who have actually logged a session. Return every session record belonging to those two users.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [15418, 8054, 2985, '2025-03-11 04:00:00', 928, 40]
  [17248, 8054, 375, '2023-09-17 10:00:00', 1858, 40]
  [19078, 8054, 665, '2025-03-23 16:00:00', None, 40]
  [15479, 8151, 288, '2026-02-28 05:00:00', 959, 45]
  [17309, 8151, 578, '2024-08-06 11:00:00', 1889, 45]
*/


-- Write your SQL solution below:

WITH session_users AS (
    SELECT u.user_id, u.signup_date
    FROM users u
    WHERE EXISTS (
        SELECT 1
        FROM user_sessions s
        WHERE s.user_id = u.user_id
    )
),
extremes AS (
    SELECT su.user_id
    FROM session_users su
    WHERE su.signup_date = (SELECT MIN(signup_date) FROM session_users)
    UNION
    SELECT a.user_id
    FROM session_users a
    LEFT JOIN session_users later
        ON later.signup_date > a.signup_date
    WHERE later.user_id IS NULL
)
SELECT us.session_id,
       us.user_id,
       us.device_id,
       us.session_start,
       us.session_duration_sec,
       us.pages_viewed
FROM user_sessions us
JOIN extremes e ON us.user_id = e.user_id
ORDER BY us.user_id, us.session_id;
