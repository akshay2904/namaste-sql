-- ======================================================================
-- Read the Manual
-- ======================================================================
-- Difficulty : Easy
-- Company    : Yelp
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/tutorial_content_count
-- ======================================================================

/*
The content team wants to know how much of the catalog is explicitly framed as a "how-to" walkthrough. Count how many content items have the word 'how' somewhere in their title (case-insensitive).

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['howto_count']:
  [20]
*/


-- Write your SQL solution below:

SELECT COUNT(*) AS howto_count
FROM content_items
WHERE LOWER(title) LIKE '%how%'
