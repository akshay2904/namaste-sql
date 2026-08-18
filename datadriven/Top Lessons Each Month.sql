-- ======================================================================
-- Top Lessons Each Month
-- ======================================================================
-- Difficulty : Medium
-- Company    : Walmart
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_lessons_each_month
-- ======================================================================

/*
From the lesson progress data, surface the three most-completed lessons each month. The content team uses this to guide investment decisions for the next quarter.

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Expected output ['month', 'page_url', 'completion_count', 'rank']:
  ['2022-01', '/about', 1, 1]
  ['2022-01', '/products', 1, 1]
  ['2022-02', '/checkout', 1, 1]
  ['2026-01', '/products', 2, 1]
  ['2026-02', '/docs/api', 2, 1]
*/


-- Write your SQL solution below:

WITH monthly AS (
  SELECT strftime('%Y-%m', viewed_at) AS month,
         page_url,
         COUNT(*) AS completion_count
  FROM page_views
  GROUP BY 1, 2
),
ranked AS (
  SELECT month,
         page_url,
         completion_count,
         RANK() OVER (PARTITION BY month ORDER BY completion_count DESC) AS rnk
  FROM monthly
)
SELECT month, page_url, completion_count, rnk AS rank
FROM ranked
WHERE rnk <= 3
ORDER BY month, rnk
