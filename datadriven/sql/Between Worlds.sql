-- ======================================================================
-- Between Worlds
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/multi_os_users
-- ======================================================================

/*
Find the users whose sessions span more than one operating system. Return every session those users logged, with user ID, OS name, device type, and session start.

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

Expected output ['user_id', 'os_name', 'device_type', 'session_start']:
  [197, 'Windows', 'tablet', '2026-02-02 01:00:00']
  [294, 'macOS', 'smart_tv', '2026-03-03 02:00:00']
  [391, 'Linux', 'wearable', '2026-04-04 03:00:00']
  [488, 'tvOS', 'mobile', '2026-05-05 04:00:00']
  [585, 'watchOS', 'desktop', '2026-06-06 05:00:00']
*/


-- Write your SQL solution below:

SELECT s.user_id, d.os_name, d.device_type, s.session_start
FROM user_sessions s
JOIN devices d ON s.device_id = d.device_id
WHERE s.user_id IN (
    SELECT s2.user_id
    FROM user_sessions s2
    JOIN devices d2 ON s2.device_id = d2.device_id
    GROUP BY s2.user_id
    HAVING COUNT(DISTINCT d2.os_name) > 1
)
