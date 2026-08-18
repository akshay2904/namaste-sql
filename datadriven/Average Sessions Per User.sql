-- ======================================================================
-- Average Sessions Per User
-- ======================================================================
-- Difficulty : Hard
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_sessions_per_user
-- ======================================================================

/*
The board deck needs a single engagement benchmark: the average number of sessions per user across the entire platform.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['avg_sessions_per_user']:
  [3.389830508474576]
*/


-- Write your SQL solution below:

SELECT AVG(session_count) AS avg_sessions_per_user
FROM (
  SELECT user_id, COUNT(*) AS session_count
  FROM user_sessions
  GROUP BY user_id
)
