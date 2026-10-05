-- ======================================================================
-- Content Type Distribution
-- ======================================================================
-- Difficulty : Easy
-- Company    : Linux
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/content_type_distribution
-- ======================================================================

/*
The editorial team wants a quick census of the content library. How many items exist for each content type? List them alphabetically.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['content_type', 'item_count']:
  ['article', 40]
  ['livestream', 40]
  ['podcast', 40]
  ['short', 40]
  ['video', 40]
*/


-- Write your SQL solution below:

SELECT content_type, COUNT(*) AS item_count
FROM content_items
GROUP BY content_type
ORDER BY content_type
