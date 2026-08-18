-- ======================================================================
-- First Half of Page Views
-- ======================================================================
-- Difficulty : Medium
-- Company    : Bosch
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/first_half_of_page_views
-- ======================================================================

/*
Retrieve the first half of all page view records based on the total row count. Include each record's row number alongside all view details (view ID, page URL, user ID, referrer, duration in milliseconds, device, and viewed-at timestamp). Results should be ordered by view ID.

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Expected output ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at', 'rn']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00', 1]
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00', 2]
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00', 3]
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00', 4]
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00', 5]
*/


-- Write your SQL solution below:

SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY view_id) AS rn
    FROM page_views
) sub
WHERE rn <= (SELECT COUNT(*) / 2 FROM page_views)
ORDER BY view_id
