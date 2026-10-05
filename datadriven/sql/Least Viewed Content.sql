-- ======================================================================
-- Least Viewed Content
-- ======================================================================
-- Difficulty : Medium
-- Company    : TikTok
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/least_viewed_content
-- ======================================================================

/*
The content team is pruning dead pages, where each page_url is already stored in its final canonical form and should be treated exactly as recorded. Find the content with the fewest unique viewers, counting a visitor who returns to the same page many times only once. If several pages share that lowest viewer count, include all of them.

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Expected output ['content_id', 'unique_viewers']:
  ['/docs/api', 4]
  ['/home', 4]
*/


-- Write your SQL solution below:

SELECT page_url AS content_id,
       COUNT(DISTINCT user_id) AS unique_viewers
FROM page_views
GROUP BY page_url
HAVING COUNT(DISTINCT user_id) = (
  SELECT MIN(viewer_count)
  FROM (
    SELECT COUNT(DISTINCT user_id) AS viewer_count
    FROM page_views
    GROUP BY page_url
  )
)
ORDER BY unique_viewers ASC
