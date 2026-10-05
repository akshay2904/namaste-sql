-- ======================================================================
-- Sessions Per Device Type
-- ======================================================================
-- Difficulty : Easy
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/sessions_per_device_type
-- ======================================================================

/*
How many sessions occurred on each device type? Show the counts from most to fewest.

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

Expected output ['device_type', 'session_count']:
  ['smart_tv', 37]
  ['tablet', 36]
  ['desktop', 36]
  ['mobile', 35]
  ['wearable', 33]
*/


-- Write your SQL solution below:

SELECT d.device_type, COUNT(*) AS session_count
FROM user_sessions us
JOIN devices d ON us.device_id = d.device_id
GROUP BY d.device_type
ORDER BY session_count DESC
