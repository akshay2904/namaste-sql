-- ======================================================================
-- Engagement by Content Type
-- ======================================================================
-- Difficulty : Medium
-- Company    : Yelp
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/engagement_by_content_type
-- ======================================================================

/*
The content team uses total duration as a proxy for engagement and wants to know which formats consume the most viewer time. Show each content type's total duration in seconds, sorted from highest total duration to lowest.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['content_type', 'total_duration', 'item_count']:
  ['video', 101100, 40]
  ['livestream', 99220, 40]
  ['short', 97340, 40]
  ['podcast', 95460, 40]
  ['article', 0, 40]
*/


-- Write your SQL solution below:

SELECT content_type,
       COALESCE(SUM(duration_seconds), 0) AS total_duration,
       COUNT(*) AS item_count
FROM content_items
GROUP BY content_type
ORDER BY total_duration DESC, content_type ASC
