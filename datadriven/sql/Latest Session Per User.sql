-- ======================================================================
-- Latest Session Per User
-- ======================================================================
-- Difficulty : Easy
-- Company    : Moore Capital Management
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/latest_session_per_user
-- ======================================================================

/*
The retention team is building a recency model and needs each user's most recent session start date alongside their user ID.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id', 'latest_session_start']:
  [100, '2026-09-25 08:00:00']
  [197, '2026-10-26 09:00:00']
  [294, '2026-11-27 10:00:00']
  [391, '2026-12-28 11:00:00']
  [488, '2026-09-17 20:00:00']
*/


-- Write your SQL solution below:

SELECT user_id, MAX(session_start) AS latest_session_start
FROM user_sessions
GROUP BY user_id
ORDER BY user_id
