-- ======================================================================
-- Daily Session and User Counts
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/daily_session_and_user_counts
-- ======================================================================

/*
The product analytics team is building a daily engagement dashboard. For each date, show the total number of sessions and the number of unique users, listed chronologically.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['session_date', 'total_sessions', 'unique_users']:
  ['2023-01-01', 2, 2]
  ['2023-01-05', 1, 1]
  ['2023-01-09', 1, 1]
  ['2024-12-18', 2, 2]
  ['2025-11-07', 2, 2]
*/


-- Write your SQL solution below:

SELECT
    DATE(session_start) AS session_date,
    COUNT(*) AS total_sessions,
    COUNT(DISTINCT user_id) AS unique_users
FROM user_sessions
GROUP BY DATE(session_start)
ORDER BY session_date
