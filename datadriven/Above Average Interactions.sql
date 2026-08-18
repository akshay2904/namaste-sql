-- ======================================================================
-- Above Average Interactions
-- ======================================================================
-- Difficulty : Easy
-- Company    : Samsara
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/above_average_interactions
-- ======================================================================

/*
A downstream report shows a small set of power users drives most of the platform's session volume. Pull every user whose total session count exceeds the average session count across all users, and show their user ID alongside that total.

Table: user_sessions(session_id, user_id, session_start)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id', 'total_sessions']:
  [100, 8]
  [1943, 5]
  [1846, 5]
  [1749, 5]
  [1652, 5]
*/


-- Write your SQL solution below:

SELECT user_id, COUNT(*) AS total_sessions
FROM user_sessions
GROUP BY user_id
HAVING COUNT(*) > (
    SELECT AVG(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM user_sessions
        GROUP BY user_id
    ) sub
)
ORDER BY total_sessions DESC
