-- ======================================================================
-- Pages Viewed by Session Duration
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/pages_viewed_by_session_duration
-- ======================================================================

/*
Sessions are bucketed by their duration. For each bucket, show the number of sessions and the average pages viewed, ranked from highest average pages down.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['duration_bucket', 'session_count', 'avg_pages']:
  ['5_to_15min', 44, 23.613636363636363]
  ['over_30min', 76, 23.19736842105263]
  ['15_to_30min', 62, 22.725806451612904]
  ['1_to_5min', 17, 19.705882352941178]
  ['under_1min', 1, 3]
*/


-- Write your SQL solution below:

SELECT
    CASE
        WHEN session_duration_sec < 60 THEN 'under_1min'
        WHEN session_duration_sec < 300 THEN '1_to_5min'
        WHEN session_duration_sec < 900 THEN '5_to_15min'
        WHEN session_duration_sec < 1800 THEN '15_to_30min'
        ELSE 'over_30min'
    END AS duration_bucket,
    COUNT(*) AS session_count,
    AVG(pages_viewed) AS avg_pages
FROM user_sessions
GROUP BY duration_bucket
ORDER BY avg_pages DESC, duration_bucket
