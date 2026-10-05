-- ======================================================================
-- Exclusive Users per Device Type
-- ======================================================================
-- Difficulty : Medium
-- Company    : Quora
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/exclusive_users_per_device_type
-- ======================================================================

/*
For each device type, count users who have only ever used that single device type across all their sessions. Return the device type and exclusive user count.

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

Expected output ['device_type', 'exclusive_user_count']:
  ['smart_tv', 12]
  ['tablet', 12]
  ['desktop', 11]
  ['mobile', 11]
  ['wearable', 11]
*/


-- Write your SQL solution below:

WITH exclusive AS (
    SELECT s.user_id, MIN(d.device_type) AS device_type
    FROM user_sessions s
    JOIN devices d ON s.device_id = d.device_id
    GROUP BY s.user_id
    HAVING COUNT(DISTINCT d.device_type) = 1
)
SELECT device_type, COUNT(*) AS exclusive_user_count
FROM exclusive
GROUP BY device_type
ORDER BY exclusive_user_count DESC, device_type ASC
