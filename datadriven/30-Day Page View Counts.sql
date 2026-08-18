-- ======================================================================
-- 30-Day Page View Counts
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/30_day_page_view_counts
-- ======================================================================

/*
The product analytics team needs a 30-day engagement snapshot ending on December 28, 2026 (inclusive). For each user who visited the site during that window, report their user ID and total page view count.

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Expected output ['user_id', 'total_views']:
  [1555, 10]
  [1652, 10]
  [1749, 10]
  [1846, 10]
  [None, 1]
*/


-- Write your SQL solution below:

SELECT user_id, COUNT(*) AS total_views
FROM page_views
WHERE DATE(viewed_at) BETWEEN '2026-11-29' AND '2026-12-28'
GROUP BY user_id
ORDER BY total_views DESC, user_id
