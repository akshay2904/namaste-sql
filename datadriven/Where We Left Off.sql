-- ======================================================================
-- Where We Left Off
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/day-after-day-consecutive-logins
-- ======================================================================

/*
We run a subscription app, and a user can start many sessions over their lifetime. Before a support call, the agent needs the page count from each user's most recent session, listed by user.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id', 'pages_viewed']:
  [100, 40]
  [197, 43]
  [294, 46]
  [391, 49]
  [488, 32]
*/


-- Write your SQL solution below:

WITH ranked AS (
  SELECT user_id,
         pages_viewed,
         ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY session_start DESC, session_id DESC) AS rn
  FROM user_sessions
)
SELECT user_id, pages_viewed
FROM ranked
WHERE rn = 1
ORDER BY user_id
