-- ======================================================================
-- Suspected Bot Sessions
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/suspected_bot_sessions
-- ======================================================================

/*
Sessions shorter than 100 seconds get flagged as potential bot activity. Return the session ID, user ID, and session duration for each suspect session in 2026.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['session_id', 'user_id', 'session_duration_sec']:
  [7061, 197, 53]
  [7122, 294, 76]
  [7183, 391, 99]
*/


-- Write your SQL solution below:

SELECT session_id, user_id, session_duration_sec
FROM user_sessions
WHERE session_duration_sec < 100 AND strftime('%Y', session_start) = '2026'
