-- ======================================================================
-- Session Page View Distance
-- ======================================================================
-- Difficulty : Hard
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/session_page_view_distance
-- ======================================================================

/*
The UX research team is studying engagement depth within sessions. For each session, identify the first and last page view by view_id, then compute the distance as the last view's dur_ms minus the first view's dur_ms. Discard any session that contains only a single view. Return the average distance across all qualifying sessions. Sessions are linked to page views through user_id.

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

Expected output ['avg_distance']:
  [5883.493150684932]
*/


-- Write your SQL solution below:

WITH page_ranked AS (
  SELECT pv.user_id, us.session_id, pv.dur_ms, pv.view_id,
         ROW_NUMBER() OVER (PARTITION BY us.session_id ORDER BY pv.view_id ASC) AS rn_asc,
         ROW_NUMBER() OVER (PARTITION BY us.session_id ORDER BY pv.view_id DESC) AS rn_desc,
         COUNT(*) OVER (PARTITION BY us.session_id) AS view_count
  FROM page_views pv
  INNER JOIN user_sessions us ON pv.user_id = us.user_id
),
session_dist AS (
  SELECT f.session_id,
         l.dur_ms - f.dur_ms AS distance
  FROM page_ranked f
  INNER JOIN page_ranked l ON f.session_id = l.session_id
  WHERE f.rn_asc = 1 AND l.rn_desc = 1
  AND f.view_count > 1
)
SELECT AVG(distance) AS avg_distance FROM session_dist
