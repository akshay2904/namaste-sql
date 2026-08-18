-- ======================================================================
-- Low-Engagement Sessions
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/low_engagement_sessions
-- ======================================================================

/*
The retention team is identifying users with weak engagement. Find every user whose average session duration falls below 1,000 seconds. Show the user ID and their average duration.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id', 'avg_duration']:
  [197, 973]
  [294, 996]
  [488, 888.6666666666666]
  [2331, 600]
  [2719, 600]
*/


-- Write your SQL solution below:

SELECT user_id, AVG(session_duration_sec) AS avg_duration
FROM user_sessions
GROUP BY user_id
HAVING AVG(session_duration_sec) < 1000
