-- ======================================================================
-- The Upgrade Divide
-- ======================================================================
-- Difficulty : Medium
-- Company    : Apple
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/ios_adoption_by_age_bucket
-- ======================================================================

/*
Our growth team wants to know how far iOS 16, 17, and 18 have spread across our age groups. For each age group, show the number of users who ran a session on one of those iOS versions next to the total number of users with any session, largest groups first.

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

Expected output ['age_bucket', 'ios_users', 'total_users']:
  ['65+', 1, 9]
  ['55-64', 0, 9]
  ['45-54', 1, 9]
  ['35-44', 1, 8]
  ['18-24', 0, 8]
*/


-- Write your SQL solution below:

SELECT u.age_bucket,
    COUNT(DISTINCT CASE
        WHEN d.os_name = 'iOS'
         AND (d.os_version LIKE '16%' OR d.os_version LIKE '17%' OR d.os_version LIKE '18%')
        THEN u.user_id
    END) AS ios_users,
    COUNT(DISTINCT u.user_id) AS total_users
FROM users u
JOIN user_sessions s ON u.user_id = s.user_id
LEFT JOIN devices d ON s.device_id = d.device_id
WHERE u.age_bucket IS NOT NULL
GROUP BY u.age_bucket
ORDER BY total_users DESC, u.age_bucket DESC
