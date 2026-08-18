-- ======================================================================
-- Endless Scroll
-- ======================================================================
-- Difficulty : Medium
-- Company    : Yelp
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_users_by_pages_viewed
-- ======================================================================

/*
We measure engagement as the total pages a visitor loads across all of their sessions. Show the five most engaged users with their total page count, from most to fewest.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id', 'total_pages']:
  [1361, 145]
  [391, 145]
  [1652, 140]
  [682, 140]
  [8151, 135]
*/


-- Write your SQL solution below:

SELECT user_id, SUM(pages_viewed) AS total_pages
FROM user_sessions
GROUP BY user_id
ORDER BY total_pages DESC
LIMIT 5
