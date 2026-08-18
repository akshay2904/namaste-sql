-- ======================================================================
-- The Day-7 Retention Cohort
-- ======================================================================
-- Difficulty : Medium
-- Company    : Merilytics
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_day_7_retention_cohort
-- ======================================================================

/*
For each weekly signup cohort, compute what percentage of users came back and performed an action on day 7 or later. Show the cohort week, total signups, retained users, and retention rate.

Table: users(user_id, signup_date)

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Expected output ['cohort_week', 'total_signups', 'retained_users', 'retention_pct']:
  ['2023-W00', 1, 0, 0]
  ['2023-W02', 3, 0, 0]
  ['2023-W03', 2, 0, 0]
  ['2024-W14', 4, 1, 25]
  ['2024-W17', 5, 0, 0]
*/


-- Write your SQL solution below:

SELECT strftime('%Y-W%W', u.signup_date) AS cohort_week,
       COUNT(DISTINCT u.user_id) AS total_signups,
       COUNT(DISTINCT CASE WHEN julianday(a.viewed_at) - julianday(u.signup_date) >= 7 THEN a.user_id END) AS retained_users,
       ROUND(CAST(COUNT(DISTINCT CASE WHEN julianday(a.viewed_at) - julianday(u.signup_date) >= 7 THEN a.user_id END) AS DOUBLE) / COUNT(DISTINCT u.user_id) * 100, 1) AS retention_pct
FROM users u
LEFT JOIN page_views a ON u.user_id = a.user_id
WHERE julianday('now') - julianday(u.signup_date) >= 7
GROUP BY cohort_week
ORDER BY cohort_week
