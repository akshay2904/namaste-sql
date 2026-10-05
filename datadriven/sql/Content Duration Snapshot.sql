-- ======================================================================
-- Content Duration Snapshot
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amadeus
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/content_duration_snapshot
-- ======================================================================

/*
The content team is prioritizing which items to feature on the homepage based on length. List all content items with their ID, title, and duration in seconds, longest first.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['content_id', 'title', 'duration_seconds']:
  [4500, 'How to Data Science', 4760]
  [10004600, 'How to Data Science', 4760]
  [4457, 'Exploring Web Development', 4713]
  [10004599, 'Exploring Web Development', 4713]
  [4414, 'Breaking Down DevOps', 4666]
*/


-- Write your SQL solution below:

SELECT content_id, title, duration_seconds
FROM content_items
ORDER BY duration_seconds DESC
