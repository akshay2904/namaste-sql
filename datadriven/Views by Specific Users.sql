-- ======================================================================
-- Views by Specific Users
-- ======================================================================
-- Difficulty : Easy
-- Company    : Merilytics
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/views_by_specific_users
-- ======================================================================

/*
The trust and safety team flagged three accounts for review: alice, aaron42, and amelia. Pull every content view associated with those users. Show the view ID, content ID, timestamp, and watch duration, by view ID.

Table: content_views(view_id, content_id, user_id, device_id, viewed_at, watch_seconds)

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - content_views ['view_id', 'content_id', 'user_id', 'device_id', 'viewed_at', 'watch_seconds']:
  [7053, 372, 1361, 404, '2026-02-02 01:07:00', 41]
  [7106, 501, 2622, 607, '2026-03-03 02:14:00', 72]
  [7159, 630, 3883, 810, '2026-04-04 03:21:00', 103]
  [7212, 759, 5144, 1013, '2026-05-05 04:28:00', 134]
  [7265, 888, 6405, 1216, '2026-06-06 05:35:00', 165]

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['view_id', 'content_id', 'viewed_at', 'watch_seconds']:
  [9862, 2909, '2026-07-27 06:18:00', 1684]
  [12300, 243, '2026-05-17 04:40:00', 3110]
  [10012354, 2909, '2025-06-27 06:18:00', 1684]
  [10012400, 243, '2026-04-17 04:40:00', 3110]
*/


-- Write your SQL solution below:

SELECT cv.view_id, cv.content_id, cv.viewed_at, cv.watch_seconds
FROM content_views cv
JOIN users u ON cv.user_id = u.user_id
WHERE u.username IN ('alice', 'aaron42', 'amelia')
ORDER BY cv.view_id;
