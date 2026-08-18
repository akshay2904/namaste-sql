-- ======================================================================
-- Activity Histogram
-- ======================================================================
-- Difficulty : Easy
-- Company    : Merilytics
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/activity_histogram
-- ======================================================================

/*
Retention modeling suspects the platform has a bimodal usage pattern: a cluster of one-and-done visitors and a cluster of heavy regulars with little in between. Build a histogram of session counts so the team can see how many users fall at each level of activity, from lowest to highest.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['session_count', 'user_count']:
  [1, 9]
  [2, 2]
  [3, 28]
  [5, 19]
  [8, 1]
*/


-- Write your SQL solution below:

WITH user_counts AS (
    SELECT user_id, COUNT(*) AS session_count
    FROM user_sessions
    GROUP BY user_id
)
SELECT session_count, COUNT(*) AS user_count
FROM user_counts
GROUP BY session_count
ORDER BY session_count
