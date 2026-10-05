-- ======================================================================
-- Content Sorted by Duration
-- ======================================================================
-- Difficulty : Easy
-- Company    : Allstate
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/content_sorted_by_duration
-- ======================================================================

/*
The content team wants to see how each item compares to the longest piece in the catalog. Return all content items with their full details, duration as a decimal, and the difference in seconds from the longest item, listed from longest to shortest.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date', 'duration_decimal', 'diff_from_longest']:
  [4500, 'How to Data Science', 'video', 4760, 100, '2025-05-17', 4760, 0]
  [10004600, 'How to Data Science', 'video', 4760, 100, '2026-04-17', 4760, 0]
  [4457, 'Exploring Web Development', 'livestream', 4713, None, '2026-04-16', 4713, 47]
  [4414, 'Breaking Down DevOps', 'short', 4666, 4756, '2025-03-15', 4666, 94]
  [4371, 'Behind the Scenes of Product Management', 'podcast', 4619, 4659, '2026-02-14', 4619, 141]
*/


-- Write your SQL solution below:

SELECT
    *,
    CAST(duration_seconds AS REAL) AS duration_decimal,
    CAST((SELECT MAX(duration_seconds) FROM content_items) - duration_seconds AS REAL) AS diff_from_longest
FROM content_items
ORDER BY duration_seconds DESC, content_id ASC
