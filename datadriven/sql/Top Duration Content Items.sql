-- ======================================================================
-- Top Duration Content Items
-- ======================================================================
-- Difficulty : Easy
-- Company    : Spotify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_duration_content_items
-- ======================================================================

/*
Find all content items whose duration is the highest among all items sharing the same content type, published since 2026. Show the unique content IDs and titles.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['content_id', 'title']:
  [4371, 'Behind the Scenes of Product Management']
  [4457, 'Exploring Web Development']
  [10004600, 'How to Data Science']
*/


-- Write your SQL solution below:

SELECT DISTINCT ci.content_id, ci.title
FROM content_items ci
WHERE ci.duration_seconds = (
    SELECT MAX(ci2.duration_seconds)
    FROM content_items ci2
    WHERE ci2.content_type = ci.content_type
)
AND ci.publish_date >= '2026-01-01'
ORDER BY ci.content_id
