-- ======================================================================
-- The Ones Who Finish
-- ======================================================================
-- Difficulty : Medium
-- Company    : DoorDash
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the-ones-who-finish
-- ======================================================================

/*
A fitness streaming app measures engagement by how far members get through each clip before dropping off, comparing time watched against the clip's full length. For views logged this year, find the average completion and the number of views per content format, ignoring items with no recorded length, with the most absorbing format first.

Table: content_views(view_id, content_id, user_id, viewed_at, watch_seconds)

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_views ['view_id', 'content_id', 'user_id', 'device_id', 'viewed_at', 'watch_seconds']:
  [7053, 372, 1361, 404, '2026-02-02 01:07:00', 41]
  [7106, 501, 2622, 607, '2026-03-03 02:14:00', 72]
  [7159, 630, 3883, 810, '2026-04-04 03:21:00', 103]
  [7212, 759, 5144, 1013, '2026-05-05 04:28:00', 134]
  [7265, 888, 6405, 1216, '2026-06-06 05:35:00', 165]

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['content_format', 'avg_completion_rate', 'view_count']:
  ['podcast', 1.388, 20]
  ['short', 1.18, 20]
  ['video', 1.039, 20]
  ['livestream', 0.723, 20]
*/


-- Write your SQL solution below:

SELECT ci.content_type AS content_format,
       ROUND(AVG(cv.watch_seconds * 1.0 / ci.duration_seconds), 3) AS avg_completion_rate,
       COUNT(*) AS view_count
FROM content_views cv
JOIN content_items ci ON cv.content_id = ci.content_id
WHERE strftime('%Y', cv.viewed_at) = '2026'
  AND ci.duration_seconds > 0
GROUP BY ci.content_type
ORDER BY avg_completion_rate DESC
