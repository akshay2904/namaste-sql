-- ======================================================================
-- High Engagement Pages
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/high_engagement_pages
-- ======================================================================

/*
Each page view tracks duration in milliseconds. For each page URL, convert the duration to seconds and sum the total viewing time across all views from users who have session records. Only return pages with more than 5 seconds of total viewing time. Return the page URL and total viewing time in seconds.

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['session_id', 'result']:
  [8098, 142972]
  [9318, 142972]
  [10538, 142972]
  [11758, 142972]
  [12978, 142972]
*/


-- Write your SQL solution below:

SELECT b.session_id, SUM(a.dur_ms) AS result
FROM page_views a
JOIN user_sessions b ON a.user_id = b.user_id
GROUP BY b.session_id
ORDER BY result DESC
