-- ======================================================================
-- Daily Cross-Platform Users
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/daily_cross_platform_users
-- ======================================================================

/*
The growth team is tracking daily cross-platform engagement for mobile and web users. For each date, count the unique users who had at least one session on a 'mobile' or 'web' device. Show the date and the user count, chronologically.

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

Expected output ['session_date', 'user_count']:
  ['2023-01-25', 1]
  ['2023-05-01', 1]
  ['2023-09-05', 1]
  ['2023-09-21', 1]
  ['2024-04-06', 1]
*/


-- Write your SQL solution below:

SELECT DATE(us.session_start) AS session_date,
       COUNT(DISTINCT us.user_id) AS user_count
FROM user_sessions us
JOIN devices d ON us.device_id = d.device_id
WHERE d.device_type IN ('mobile', 'web')
GROUP BY DATE(us.session_start)
ORDER BY session_date;
