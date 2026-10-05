-- ======================================================================
-- Users Who Churned in February
-- ======================================================================
-- Difficulty : Hard
-- Company    : ESPN
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/users_who_churned_in_february
-- ======================================================================

/*
Find all users who had sessions in January 2026 but none in February 2026.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id']:
  [1264]
  [488]
  [1652]
  [876]
  [100]
*/


-- Write your SQL solution below:

SELECT DISTINCT user_id
FROM user_sessions
WHERE session_start >= '2026-01-01'
  AND session_start < '2026-02-01'
  AND user_id NOT IN (
      SELECT DISTINCT user_id
      FROM user_sessions
      WHERE session_start >= '2026-02-01'
        AND session_start < '2026-03-01'
  )
