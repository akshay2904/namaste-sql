-- ======================================================================
-- First Time Learners Per Day
-- ======================================================================
-- Difficulty : Medium
-- Company    : JPMorgan Chase
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/first_time_learners_per_day
-- ======================================================================

/*
For every date in the data, count the number of users who started their very first session on that day.

Table: user_sessions(session_id, user_id, session_start, session_duration_sec)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['first_session_date', 'new_user_count']:
  ['2023-01-01', 2]
  ['2023-01-05', 1]
  ['2023-01-09', 1]
  ['2026-01-05', 2]
  ['2026-02-02', 2]
*/


-- Write your SQL solution below:

WITH first_sessions AS (
  SELECT user_id, MIN(DATE(session_start)) AS first_session_date
  FROM user_sessions
  GROUP BY user_id
)
SELECT first_session_date, COUNT(*) AS new_user_count
FROM first_sessions
GROUP BY first_session_date
ORDER BY first_session_date
