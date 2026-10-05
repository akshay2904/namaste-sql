-- ======================================================================
-- Where the Minutes Go
-- ======================================================================
-- Difficulty : Easy
-- Company    : Spotify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/user_engagement_totals
-- ======================================================================

/*
We keep two independent logs for the web product: one row per session in the session log and one row per page view in the page-view log, and a single person piles up many of each. For everyone carrying a real user id in either log, report their total time across all sessions rounded to the nearest minute together with how many different pages they opened.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Expected output ['user_id', 'total_minutes', 'unique_content_count']:
  [100, 364, 2]
  [391, 85, 0]
  [1070, 98, 3]
  [1555, 108, 10]
  [1652, 58, 11]
*/


-- Write your SQL solution below:

SELECT
    u.user_id,
    COALESCE(ROUND(s.total_secs / 60.0), 0) AS total_minutes,
    COALESCE(p.unique_content, 0) AS unique_content_count
FROM (
    SELECT user_id FROM user_sessions WHERE user_id IS NOT NULL
    UNION
    SELECT user_id FROM page_views WHERE user_id IS NOT NULL
) u
LEFT JOIN (
    SELECT user_id, SUM(session_duration_sec) AS total_secs
    FROM user_sessions
    GROUP BY user_id
) s ON u.user_id = s.user_id
LEFT JOIN (
    SELECT user_id, COUNT(DISTINCT page_url) AS unique_content
    FROM page_views
    GROUP BY user_id
) p ON u.user_id = p.user_id
