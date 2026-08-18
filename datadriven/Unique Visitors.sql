-- ======================================================================
-- Unique Visitors
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/unique_visitors
-- ======================================================================

/*
The product team is building a monthly active users report for the board. For each calendar month in the session data, tally the number of individual users who visited at least once. Only include months that had more than two unique visitors. List the months from most recent to oldest.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['month', 'unique_visitors']:
  ['2026-12', 5]
  ['2026-11', 5]
  ['2026-10', 10]
  ['2026-06', 11]
  ['2026-03', 6]
*/


-- Write your SQL solution below:

SELECT
    STRFTIME('%Y-%m', session_start) AS month,
    COUNT(DISTINCT user_id) AS unique_visitors
FROM user_sessions
GROUP BY STRFTIME('%Y-%m', session_start)
HAVING COUNT(DISTINCT user_id) > 2
ORDER BY month DESC
