-- ======================================================================
-- Average Watch Time by Format
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_watch_time_by_format
-- ======================================================================

/*
The content team is deciding which formats to invest in for next quarter. For each content type, show the average watch time across all views so they can see which formats hold attention.

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

Expected output ['content_type', 'avg_watch_time']:
  ['article', 1625.2631578947369]
  ['livestream', 1453.2222222222222]
  ['podcast', 1570.3333333333333]
  ['short', 1597.888888888889]
  ['video', 1579.578947368421]
*/


-- Write your SQL solution below:

SELECT
    ci.content_type,
    AVG(cv.watch_seconds) AS avg_watch_time
FROM content_items ci
INNER JOIN content_views cv ON ci.content_id = cv.content_id
GROUP BY ci.content_type
ORDER BY ci.content_type
