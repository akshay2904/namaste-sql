-- ======================================================================
-- Titles Ending With S
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/titles_ending_with_s
-- ======================================================================

/*
Pull all content items whose title ends with the letter 's'. For each item, show the content ID, title, content type, duration in seconds, creator ID, and publish date.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [544, 'Breaking Down DevOps', 'short', 436, 876, '2025-09-09']
  [974, 'Breaking Down DevOps', 'short', 906, None, '2025-07-19']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
*/


-- Write your SQL solution below:

SELECT content_id,
       title,
       content_type,
       duration_seconds,
       creator_id,
       publish_date
FROM content_items
WHERE title LIKE '%s'
ORDER BY title;
