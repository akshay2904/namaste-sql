-- ======================================================================
-- Session Logins Dec 13 to 19
-- ======================================================================
-- Difficulty : Easy
-- Company    : Sears
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/session_logins_dec_13_to_19
-- ======================================================================

/*
The security team is investigating a suspicious login window. Find all unique users with a session start between December 13 and December 19, 2026, inclusive.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id']:
  [1167]
*/


-- Write your SQL solution below:

SELECT DISTINCT user_id
FROM user_sessions
WHERE session_start BETWEEN '2026-12-13' AND '2026-12-19'
