-- ======================================================================
-- The Path Not Taken
-- ======================================================================
-- Difficulty : Hard
-- Company    : Lyft
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/adopters_before_migration
-- ======================================================================

/*
The product team is measuring organic adoption of the new editor, which shows up in the page views under the URL 'new_editor' while the old one appears as 'classic_editor'. Find the users who reached the new editor without ever having opened the classic editor before their first new editor visit.

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Expected output ['user_id']:
  [None]
  [197]
  [1361]
  [1555]
  [1943]
*/


-- Write your SQL solution below:

WITH first_new AS (
  SELECT user_id, MIN(viewed_at) AS first_new_date
  FROM page_views
  WHERE page_url = 'new_editor'
  GROUP BY user_id
)
SELECT fn.user_id
FROM first_new fn
WHERE NOT EXISTS (
  SELECT 1
  FROM page_views ua
  WHERE ua.user_id = fn.user_id
    AND ua.page_url = 'classic_editor'
    AND ua.viewed_at < fn.first_new_date
);
