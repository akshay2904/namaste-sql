-- ======================================================================
-- Content Viewer Penetration
-- ======================================================================
-- Difficulty : Easy
-- Company    : Rockerbox
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/content_viewer_penetration
-- ======================================================================

/*
The growth team is measuring content adoption across the user base. What percentage of all registered users have at least one content view on record? Users who have never viewed anything should still count toward the total.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Table: content_views(view_id, content_id, user_id, device_id, viewed_at, watch_seconds)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Sample data - content_views ['view_id', 'content_id', 'user_id', 'device_id', 'viewed_at', 'watch_seconds']:
  [7053, 372, 1361, 404, '2026-02-02 01:07:00', 41]
  [7106, 501, 2622, 607, '2026-03-03 02:14:00', 72]
  [7159, 630, 3883, 810, '2026-04-04 03:21:00', 103]
  [7212, 759, 5144, 1013, '2026-05-05 04:28:00', 134]
  [7265, 888, 6405, 1216, '2026-06-06 05:35:00', 165]

Expected output ['viewer_pct']:
  [43]
*/


-- Write your SQL solution below:

SELECT ROUND(100.0 * COUNT(DISTINCT cv.user_id) / COUNT(DISTINCT u.user_id), 2) AS viewer_pct
FROM users u
LEFT JOIN content_views cv ON u.user_id = cv.user_id
