-- ======================================================================
-- Top Content by Watch Time
-- ======================================================================
-- Difficulty : Medium
-- Company    : BeyondTrust
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_content_by_watch_time
-- ======================================================================

/*
Only consider views where watch duration is recorded. Rank all content by total watch time across all viewers and return the top 3 tiers. If multiple items share the same total, include all of them. Show the content ID, title, and total watch time.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Table: content_views(view_id, content_id, user_id, device_id, viewed_at, watch_seconds)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Sample data - content_views ['view_id', 'content_id', 'user_id', 'device_id', 'viewed_at', 'watch_seconds']:
  [7053, 372, 1361, 404, '2026-02-02 01:07:00', 41]
  [7106, 501, 2622, 607, '2026-03-03 02:14:00', 72]
  [7159, 630, 3883, 810, '2026-04-04 03:21:00', 103]
  [7212, 759, 5144, 1013, '2026-05-05 04:28:00', 134]
  [7265, 888, 6405, 1216, '2026-06-06 05:35:00', 165]

Expected output ['content_id', 'title', 'lifetime_value']:
  [243, 'The Ultimate Guide to AI Trends', 6220]
  [4414, 'Breaking Down DevOps', 6158]
  [4285, 'Introduction to Cybersecurity', 6096]
*/


-- Write your SQL solution below:

WITH content_stats AS (
  SELECT
    ci.content_id,
    ci.title,
    SUM(cv.watch_seconds) AS lifetime_value,
    COUNT(*) AS view_count
  FROM content_items ci
  INNER JOIN content_views cv ON ci.content_id = cv.content_id
  WHERE cv.watch_seconds IS NOT NULL
  GROUP BY ci.content_id, ci.title
  HAVING view_count >= 1
),
ranked AS (
  SELECT
    content_id,
    title,
    lifetime_value,
    DENSE_RANK() OVER (ORDER BY lifetime_value DESC) AS rnk
  FROM content_stats
)
SELECT content_id, title, lifetime_value
FROM ranked
WHERE rnk <= 3
