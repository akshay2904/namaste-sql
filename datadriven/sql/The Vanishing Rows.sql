-- ======================================================================
-- The Vanishing Rows
-- ======================================================================
-- Difficulty : Easy
-- Company    : Clear Capital
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/null_keys_in_joins
-- ======================================================================

/*
A downstream dashboard is reporting fewer content views than expected. The content_views table has 100 records, but some views were logged without a user association. Write a query that pairs content_views to users on user_id and returns each view's ID, user ID, and username. Then reason about why the result has fewer than 100 rows.

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

Expected output ['view_id', 'user_id', 'username']:
  [7053, 1361, 'bella_q']
  [7106, 2622, 'derek']
  [7159, 3883, 'felix']
  [7212, 5144, 'haruki']
  [7265, 6405, 'jolene']
*/


-- Write your SQL solution below:

SELECT cv.view_id, cv.user_id, u.username
FROM content_views cv
JOIN users u ON cv.user_id = u.user_id
