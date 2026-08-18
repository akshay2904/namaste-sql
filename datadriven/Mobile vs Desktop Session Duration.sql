-- ======================================================================
-- Mobile vs Desktop Session Duration
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/mobile_vs_desktop_session_duration
-- ======================================================================

/*
For each user in 2025, compute the longest session on a mobile device versus the longest session on a desktop device. Consider only sessions that are linked to a known device (a session whose device cannot be identified is excluded). When a user has no session on one of the two device types, leave that side empty (NULL).

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

Expected output ['user_id', 'longest_mobile', 'longest_desktop']:
  [5047, None, None]
  [5144, 122, None]
  [6502, 432, None]
  [7472, 1672, None]
  [8442, 2912, None]
*/


-- Write your SQL solution below:

SELECT s.user_id,
    MAX(CASE WHEN d.device_type = 'mobile' THEN s.session_duration_sec END) AS longest_mobile,
    MAX(CASE WHEN d.device_type = 'desktop' THEN s.session_duration_sec END) AS longest_desktop
FROM user_sessions s
JOIN devices d ON s.device_id = d.device_id
WHERE STRFTIME('%Y', s.session_start) = '2025'
GROUP BY s.user_id
