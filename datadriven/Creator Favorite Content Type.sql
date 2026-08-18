-- ======================================================================
-- Creator Favorite Content Type
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/creator_favorite_content_type
-- ======================================================================

/*
For each content creator, which content type do they publish most often? If a creator is tied across multiple types, include all of the tied types. Show each creator and their most-published content type.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['creator_id', 'content_type']:
  [None, 'livestream']
  [100, 'video']
  [197, 'article']
  [294, 'podcast']
  [391, 'short']
*/


-- Write your SQL solution below:

WITH type_counts AS (
    SELECT
        creator_id,
        content_type,
        COUNT(*) AS cnt,
        RANK() OVER (PARTITION BY creator_id ORDER BY COUNT(*) DESC) AS rnk
    FROM content_items
    GROUP BY creator_id, content_type
)
SELECT creator_id, content_type
FROM type_counts
WHERE rnk = 1
