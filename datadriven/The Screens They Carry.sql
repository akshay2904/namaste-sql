-- ======================================================================
-- The Screens They Carry
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/devices_per_age_bucket
-- ======================================================================

/*
The product team is profiling how the 25-34 age cohort spreads its usage across hardware. Count the unique devices they use, broken down by device type, from most to fewest.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Table: devices(device_id, device_type, os_name, os_version, browser)

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

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

Expected output ['device_type', 'device_count']:
  ['smart_tv', 9]
  ['mobile', 5]
  ['tablet', 4]
  ['desktop', 4]
  ['wearable', 2]
*/


-- Write your SQL solution below:

SELECT d.device_type, COUNT(DISTINCT d.device_id) AS device_count
FROM users u
JOIN user_sessions us ON u.user_id = us.user_id
JOIN devices d ON us.device_id = d.device_id
WHERE u.age_bucket = '25-34'
GROUP BY d.device_type
ORDER BY device_count DESC
