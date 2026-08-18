-- ======================================================================
-- Average Session Duration
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_session_duration
-- ======================================================================

/*
The engagement team wants each user's average session duration, defined as their total time in sessions divided by their total number of sessions. Exclude any sessions missing a recorded duration. Return the user ID and their average.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id', 'avg_session_duration']:
  [100, 3120]
  [197, 973]
  [294, 996]
  [391, 1019]
  [488, 888.6666666666666]
*/


-- Write your SQL solution below:

WITH daily_sessions AS (
    SELECT user_id, date(session_start) AS day,
        SUM(session_duration_sec) AS total_duration,
        COUNT(*) AS session_count
    FROM user_sessions
    WHERE session_duration_sec IS NOT NULL
    GROUP BY user_id, date(session_start)
),
user_avg AS (
    SELECT user_id,
        CAST(SUM(total_duration) AS REAL) / SUM(session_count) AS avg_session_duration
    FROM daily_sessions
    GROUP BY user_id
)
SELECT user_id, avg_session_duration
FROM user_avg;
