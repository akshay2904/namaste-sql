-- ======================================================================
-- Sessions by Content Type
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/sessions_by_content_type
-- ======================================================================

/*
Per content_type in content_items, return the content_type and the count of content items in that type. Sort by count descending, breaking ties alphabetically by content_type.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['content_type', 'session_count']:
  ['article', 82]
  ['livestream', 60]
  ['podcast', 82]
  ['short', 64]
  ['video', 92]
*/


-- Write your SQL solution below:

SELECT
    content_type,
    COUNT(*) AS session_count
FROM content_items
GROUP BY content_type
ORDER BY session_count DESC, content_type ASC;
