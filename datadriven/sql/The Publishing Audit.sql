-- ======================================================================
-- The Publishing Audit
-- ======================================================================
-- Difficulty : Easy
-- Company    : Netflix
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_publishing_audit
-- ======================================================================

/*
The content analytics team is auditing the 2026 publishing pipeline. Pull all fields for content items published during that year.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']
  [501, 'Behind the Scenes of Product Management', 'podcast', 389, 779, '2026-08-08']
  [587, 'Exploring Web Development', 'livestream', 483, None, '2026-10-10']
*/


-- Write your SQL solution below:

SELECT *
FROM content_items
WHERE publish_date BETWEEN '2026-01-01' AND '2026-12-31'
