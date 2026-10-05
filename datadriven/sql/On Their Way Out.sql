-- ======================================================================
-- On Their Way Out
-- ======================================================================
-- Difficulty : Easy
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/low_engagement_user_count
-- ======================================================================

/*
We're compiling the users who signed up but never really engaged. Add up the pages each user viewed across all of their sessions, and return those whose lifetime total lands between 1 and 9 inclusive, alongside that total, quietest first.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id', 'total_pages_viewed']:
  [2331, 3]
  [2719, 3]
  [3107, 3]
  [5047, 5]
*/


-- Write your SQL solution below:

SELECT user_id, SUM(pages_viewed) AS total_pages_viewed
FROM user_sessions
GROUP BY user_id
HAVING SUM(pages_viewed) BETWEEN 1 AND 9
ORDER BY total_pages_viewed
