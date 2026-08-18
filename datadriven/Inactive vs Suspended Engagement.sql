-- ======================================================================
-- Inactive vs Suspended Engagement
-- ======================================================================
-- Difficulty : Medium
-- Company    : Microsoft
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/inactive_vs_suspended_engagement
-- ======================================================================

/*
We want to compare page view volume between inactive and suspended user segments. For each day, compute total page views for each group. Only show dates where inactive users generated more views than suspended users, earliest first.

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['view_date', 'inactive_views', 'suspended_views']:
  ['2022-01-06', 1, 0]
  ['2022-09-26', 1, 0]
  ['2023-01-11', 1, 0]
  ['2023-01-14', 1, 0]
  ['2023-02-03', 1, 0]
*/


-- Write your SQL solution below:

SELECT date(pv.viewed_at) AS view_date,
       SUM(CASE WHEN u.account_status = 'inactive'  THEN 1 ELSE 0 END) AS inactive_views,
       SUM(CASE WHEN u.account_status = 'suspended' THEN 1 ELSE 0 END) AS suspended_views
FROM page_views pv
INNER JOIN users u ON pv.user_id = u.user_id
WHERE u.account_status IN ('inactive', 'suspended')
GROUP BY date(pv.viewed_at)
HAVING inactive_views > suspended_views
ORDER BY view_date;
