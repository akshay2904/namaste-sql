-- ======================================================================
-- Platform Speed
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/platform_speed
-- ======================================================================

/*
The product team is investigating whether device type affects how long users stay engaged. For each device type, show the typical session length, the longest session on record, and how many sessions were logged. Only include device types that have at least five sessions in the data ,  anything with fewer isn't statistically meaningful. List from the device type with the longest average session down to the shortest.

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

Expected output ['device_type', 'avg_duration', 'max_duration', 'session_count']:
  ['desktop', 1465.735294117647, 7200, 36]
  ['smart_tv', 1429.1764705882354, 5400, 37]
  ['wearable', 1373.6875, 2819, 33]
  ['tablet', 1369.939393939394, 3600, 36]
  ['mobile', 1334.03125, 2912, 35]
*/


-- Write your SQL solution below:

SELECT
    d.device_type,
    AVG(s.session_duration_sec) AS avg_duration,
    MAX(s.session_duration_sec) AS max_duration,
    COUNT(*) AS session_count
FROM user_sessions s
JOIN devices d ON s.device_id = d.device_id
GROUP BY d.device_type
HAVING COUNT(*) >= 5
ORDER BY avg_duration DESC
