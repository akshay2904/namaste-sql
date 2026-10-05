-- ======================================================================
-- The Ninety-Day Comeback
-- ======================================================================
-- Difficulty : Hard
-- Company    : TravelClick
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/first_day_session_retention
-- ======================================================================

/*
A user is considered 'retained' if they start at least one additional session strictly after their very first session, but no later than 90 calendar days after that first session. Working from the user_sessions table, treat each user's earliest session_start (by calendar date) as their first session. Calculate the proportion of retained users out of all users who have any session. Return a single retention rate as a REAL value (retained users divided by total users).

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['retention_rate']:
  [0.4915254237288136]
*/


-- Write your SQL solution below:

WITH first_sessions AS (
    SELECT user_id, MIN(DATE(session_start)) AS first_date
    FROM user_sessions
    GROUP BY user_id
)
SELECT CAST(COUNT(DISTINCT us.user_id) AS REAL) / COUNT(DISTINCT fs.user_id) AS retention_rate
FROM first_sessions fs
LEFT JOIN user_sessions us
    ON fs.user_id = us.user_id
    AND DATE(us.session_start) > fs.first_date
    AND DATE(us.session_start) <= DATE(fs.first_date, '+90 day')
