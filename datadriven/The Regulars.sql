-- ======================================================================
-- The Regulars
-- ======================================================================
-- Difficulty : Hard
-- Company    : Spotify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/multi_month_active_users
-- ======================================================================

/*
Our engagement team is separating one-time visitors from users who form a real habit. From the session log, find the users who were active in at least three separate calendar months.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id']:
  [100]
  [197]
  [294]
  [391]
  [488]
*/


-- Write your SQL solution below:

SELECT user_id
FROM user_sessions
GROUP BY user_id
HAVING COUNT(DISTINCT strftime('%Y-%m', session_start)) >= 3
