-- ======================================================================
-- Active User Penetration Rate
-- ======================================================================
-- Difficulty : Hard
-- Company    : Spotify
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/active_user_penetration_rate
-- ======================================================================

/*
The product analytics team counts a user as active on a device type only when their most recent session on it falls within 30 days of the latest session recorded anywhere in the data, they have logged at least 5 sessions on that device type, and their combined session time on it reaches 10 hours (36,000 seconds). For every device type, report the share of its users who clear all three bars at once, and keep the device types where nobody qualifies so they appear with a zero rate. Return each device type with its penetration rate.

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

Expected output ['device_type', 'penetration_rate']:
  ['desktop', 0]
  ['mobile', 0]
  ['smart_tv', 0]
  ['tablet', 0]
  ['wearable', 0]
*/


-- Write your SQL solution below:

$1a
