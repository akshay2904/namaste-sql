-- ======================================================================
-- Session Rank
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/session_rank
-- ======================================================================

/*
Analytics wants to see each user's sessions ranked by engagement. Within each user, number their sessions from longest to shortest by session_duration_sec. Skip rows where session_duration_sec is NULL. Return the user_id, duration, and position number.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id', 'session_duration_sec', 'ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY session_duration_sec DESC)']:
  [100, 7200, 1]
  [100, 5400, 2]
  [100, 3600, 3]
  [100, 2330, 4]
  [100, 1870, 5]
*/


-- Write your SQL solution below:

SELECT user_id, session_duration_sec, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY session_duration_sec DESC)
FROM user_sessions
WHERE session_duration_sec IS NOT NULL
