-- ======================================================================
-- View Count Per Page
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/view_count_per_page
-- ======================================================================

/*
The content team needs a per-page view count to prioritize optimization efforts. Show each page URL and how many times it was viewed, sorted from most viewed to least.

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Expected output ['page_url', 'view_count']:
  ['/products', 16]
  ['/checkout', 16]
  ['new_editor', 14]
  ['classic_editor', 14]
  ['/settings', 14]
*/


-- Write your SQL solution below:

SELECT page_url, COUNT(*) AS view_count
FROM page_views
GROUP BY page_url
ORDER BY view_count DESC
