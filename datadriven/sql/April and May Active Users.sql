-- ======================================================================
-- April and May Active Users
-- ======================================================================
-- Difficulty : Easy
-- Company    : ActiveCampaign
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/april_and_may_active_users
-- ======================================================================

/*
The growth team needs to identify users who were active during the spring. Pull a deduplicated list of user IDs for everyone who had at least one session in April or May.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id']:
  [100]
  [391]
  [488]
  [779]
  [876]
*/


-- Write your SQL solution below:

SELECT DISTINCT user_id
FROM user_sessions
WHERE CAST(strftime('%m', session_start) AS INTEGER) IN (4, 5)
ORDER BY user_id
