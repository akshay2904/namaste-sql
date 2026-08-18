-- ======================================================================
-- Who Stayed
-- ======================================================================
-- Difficulty : Hard
-- Company    : General Assembly
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/longest_visit_streaks
-- ======================================================================

/*
Retention wants the most loyal visitors of all time: the users with the longest streaks of consecutive calendar days that had at least one session, counting only the days on or before 2026-08-10. Surface the three longest streak lengths along with every user who reached them.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id', 'streak_length']:
  [100, 1]
  [197, 1]
  [294, 1]
  [391, 1]
  [488, 1]
*/


-- Write your SQL solution below:

WITH daily AS (
    SELECT DISTINCT user_id, date(session_start) AS session_day
    FROM user_sessions
    WHERE date(session_start) <= '2026-08-10'
),
numbered AS (
    SELECT user_id, session_day,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY session_day) AS rn
    FROM daily
),
streaks AS (
    SELECT user_id,
        date(session_day, '-' || rn || ' days') AS grp,
        COUNT(*) AS streak_len
    FROM numbered
    GROUP BY user_id, grp
),
max_streaks AS (
    SELECT user_id, MAX(streak_len) AS streak_length
    FROM streaks
    GROUP BY user_id
),
ranked AS (
    SELECT user_id, streak_length,
        DENSE_RANK() OVER (ORDER BY streak_length DESC) AS rnk
    FROM max_streaks
)
SELECT user_id, streak_length
FROM ranked
WHERE rnk <= 3
ORDER BY streak_length DESC
