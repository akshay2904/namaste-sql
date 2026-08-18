-- ======================================================================
-- Daily and Weekly Active Users
-- ======================================================================
-- Difficulty : Easy
-- Company    : Deloitte
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/daily_and_weekly_active_users
-- ======================================================================

/*
The growth team needs a daily active user (DAU) time series. Count the unique users who had at least one session each calendar day, listed chronologically.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['day', 'dau']:
  ['2023-01-01', 2]
  ['2023-01-05', 1]
  ['2023-01-09', 1]
  ['2024-12-18', 2]
  ['2025-11-07', 2]
*/


-- Write your SQL solution below:

SELECT date(session_start) AS day, COUNT(DISTINCT user_id) AS dau FROM user_sessions GROUP BY date(session_start) ORDER BY day
