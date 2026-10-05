-- ======================================================================
-- User Sessions on Specific Days
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/user_sessions_on_specific_days
-- ======================================================================

/*
Pull all available fields for sessions belonging to user 197, but only sessions that started on a Saturday or Monday.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [11941, 197, 2550, '2026-10-26 09:00:00', 1893, 43]
*/


-- Write your SQL solution below:

SELECT *
FROM user_sessions
WHERE user_id = 197
  AND STRFTIME('%w', session_start) IN ('1', '6')
