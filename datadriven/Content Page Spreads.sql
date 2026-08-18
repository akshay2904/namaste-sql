-- ======================================================================
-- Content Page Spreads
-- ======================================================================
-- Difficulty : Hard
-- Company    : IBM
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/content_page_spreads
-- ======================================================================

/*
Think of content as a book where each spread pairs an even-numbered content_id (left page) with the next sequential odd-numbered content_id (right page). Pages without a matching partner should still appear with a blank on the missing side. Return the left ID, left title, and right title.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['left_id', 'left_title', 'right_title']:
  [286, 'Top 10 Mobile Apps', None]
  [372, 'Mastering Tech Startups', None]
  [458, 'Deep Dive: Cloud Computing', None]
  [544, 'Breaking Down DevOps', None]
  [630, 'How to Data Science', None]
*/


-- Write your SQL solution below:

SELECT
    l.content_id AS left_id,
    l.title AS left_title,
    r.title AS right_title
FROM content_items l
FULL OUTER JOIN content_items r
    ON l.content_id + 1 = r.content_id
    AND l.content_id % 2 = 0
    AND r.content_id % 2 = 1
WHERE l.content_id % 2 = 0
   OR r.content_id % 2 = 1
