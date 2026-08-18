-- ======================================================================
-- Where the Minutes Go
-- ======================================================================
-- Difficulty : Hard
-- Company    : Fidelity Investments
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_session_stitcher
-- ======================================================================

/*
Our analytics warehouse stores one row per page view, tagged with the visitor's device and how long they stayed on the page. Build a leaderboard of device types by total time on page, biggest first, and next to each device show the cumulative share of overall time the leaderboard has accounted for through that row.

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Expected output ['device', 'total_dwell_ms', 'running_pct']:
  ['mobile', 509664, 40.97]
  ['desktop', 480716, 79.61]
  ['tablet', 253736, 100]
*/


-- Write your SQL solution below:

WITH per_device AS (
  SELECT LOWER(device) AS device, SUM(dur_ms) AS total_dwell_ms
  FROM page_views
  GROUP BY LOWER(device)
)
SELECT
  device,
  total_dwell_ms,
  ROUND(100.0 * SUM(total_dwell_ms) OVER (ORDER BY total_dwell_ms DESC)
        / SUM(total_dwell_ms) OVER (), 2) AS running_pct
FROM per_device
ORDER BY total_dwell_ms DESC
