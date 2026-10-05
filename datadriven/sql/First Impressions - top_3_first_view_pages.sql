-- ======================================================================
-- First Impressions
-- ======================================================================
-- Difficulty : Medium
-- Company    : General Assembly
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_3_first_view_pages
-- ======================================================================

/*
We're studying the first impression our product makes, so for each visitor we look only at the earliest three pages they opened, in the order they viewed them. Across all visitors, surface the pages that appear most often in those opening views, keeping the three most common and any page tied at the third position.

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Expected output ['page_url', 'appearance_count']:
  ['classic_editor', 7]
  ['/PRODUCTS', 7]
  ['new_editor', 5]
  ['/products', 5]
  ['/settings', 4]
*/


-- Write your SQL solution below:

WITH ranked_views AS (
  SELECT user_id, page_url, viewed_at,
         ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY viewed_at ASC) AS view_order
  FROM page_views
),
page_counts AS (
  SELECT page_url, COUNT(*) AS appearance_count,
         DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
  FROM ranked_views
  WHERE view_order <= 3
  GROUP BY page_url
)
SELECT page_url, appearance_count
FROM page_counts
WHERE rnk <= 3
ORDER BY appearance_count DESC
