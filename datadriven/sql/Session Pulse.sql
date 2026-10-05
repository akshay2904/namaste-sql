-- ======================================================================
-- Session Pulse
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/session_pulse
-- ======================================================================

/*
The product manager is investigating engagement drops and wants a per-user session summary. For each user, show their average session length, the total number of sessions, and the longest session they have had. Exclude any sessions with no duration on file. Only include users who have logged at least three sessions, ranked from longest average session to shortest.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id', 'avg_duration', 'session_count', 'longest']:
  [100, 3120, 7, 7200]
  [8442, 1982, 3, 2912]
  [8345, 1951, 3, 2881]
  [1943, 1387, 5, 2307]
  [876, 1134, 4, 2054]
*/


-- Write your SQL solution below:

SELECT user_id, AVG(session_duration_sec) AS avg_duration, COUNT(*) AS session_count, MAX(session_duration_sec) AS longest
FROM user_sessions
WHERE session_duration_sec IS NOT NULL
GROUP BY user_id
HAVING COUNT(*) >= 3
ORDER BY avg_duration DESC
