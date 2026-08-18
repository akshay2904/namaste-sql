-- ======================================================================
-- The Crowded Hour
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/peak_activity_by_device
-- ======================================================================

/*
We run a consumer app and size capacity per device type, so we need each type's busiest moment. Find the session window (from its start to its start plus duration) with the most users active at the same time, and return the device type, that window written as start to end, and the number of users active.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Table: devices(device_id, device_type, os_name, os_version, browser)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Sample data - devices ['device_id', 'device_type', 'os_name', 'os_version', 'browser']:
  [201, 'desktop', 'Android', '15.1', 'Chrome']
  [230, 'tablet', 'Windows', '16.2', 'Firefox']
  [259, 'smart_tv', 'macOS', '17.0', 'Edge']
  [288, 'wearable', 'Linux', '11', 'Opera']
  [317, 'mobile', 'tvOS', '12', 'Samsung Internet']

Expected output ['device_type', 'time_period', 'user_count']:
  ['desktop', '2023-01-17 06:00:00 to 2023-01-17 06:16:30', 1]
  ['mobile', '2023-01-25 18:00:00 to 2023-01-25 18:22:42', 1]
  ['smart_tv', '2023-01-01 06:00:00 to 2023-01-01 06:04:06', 1]
  ['tablet', '2023-01-21 06:00:00 to 2023-01-21 06:41:18', 1]
  ['wearable', '2023-05-09 02:00:00 to 2023-05-09 02:39:14', 1]
*/


-- Write your SQL solution below:

WITH session_windows AS (
  SELECT d.device_type, us.session_start,
         datetime(us.session_start, '+' || us.session_duration_sec || ' seconds') AS session_end,
         us.user_id
  FROM user_sessions us INNER JOIN devices d ON us.device_id = d.device_id
),
concurrent AS (
  SELECT sw1.device_type, sw1.session_start, sw1.session_end,
         COUNT(DISTINCT sw2.user_id) AS user_count
  FROM session_windows sw1
  INNER JOIN session_windows sw2
    ON sw1.device_type = sw2.device_type
   AND sw2.session_start <= sw1.session_end
   AND sw2.session_end >= sw1.session_start
  GROUP BY sw1.device_type, sw1.session_start, sw1.session_end
),
ranked AS (
  SELECT device_type, session_start, session_end, user_count,
         ROW_NUMBER() OVER (PARTITION BY device_type ORDER BY user_count DESC, session_start ASC, session_end ASC) AS rn
  FROM concurrent
)
SELECT device_type, session_start || ' to ' || session_end AS time_period, user_count
FROM ranked WHERE rn = 1
