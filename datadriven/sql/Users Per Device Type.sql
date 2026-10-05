-- ======================================================================
-- Users Per Device Type
-- ======================================================================
-- Difficulty : Easy
-- Company    : Walmart
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/users_per_device_type
-- ======================================================================

/*
For each device type, count users who have at least one session. Include device types with zero users if applicable. Return the device type and user count.

Table: devices(device_id, device_type, os_name, os_version, browser)

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - devices ['device_id', 'device_type', 'os_name', 'os_version', 'browser']:
  [201, 'desktop', 'Android', '15.1', 'Chrome']
  [230, 'tablet', 'Windows', '16.2', 'Firefox']
  [259, 'smart_tv', 'macOS', '17.0', 'Edge']
  [288, 'wearable', 'Linux', '11', 'Opera']
  [317, 'mobile', 'tvOS', '12', 'Samsung Internet']

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['device_type', 'user_count']:
  ['desktop', 12]
  ['mobile', 11]
  ['smart_tv', 13]
  ['tablet', 13]
  ['wearable', 11]
*/


-- Write your SQL solution below:

SELECT d.device_type, COUNT(DISTINCT s.user_id) AS user_count
FROM devices d
LEFT JOIN user_sessions s ON d.device_id = s.device_id
GROUP BY d.device_type
