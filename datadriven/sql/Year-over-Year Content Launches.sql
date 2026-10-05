-- ======================================================================
-- Year-over-Year Content Launches
-- ======================================================================
-- Difficulty : Medium
-- Company    : Tesla
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/year_over_year_content_launches
-- ======================================================================

/*
Calculate the net change in content items published by each creator in 2026 compared to 2025. Show the creator and the difference (2026 count minus 2025 count).

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['creator_id', 'net_difference']:
  [585, 4]
  [3495, 4]
  [197, 2]
  [391, 2]
  [779, 2]
*/


-- Write your SQL solution below:

SELECT
    creator_id,
    SUM(CASE WHEN STRFTIME('%Y', publish_date) = '2026' THEN 1 ELSE 0 END)
    - SUM(CASE WHEN STRFTIME('%Y', publish_date) = '2025' THEN 1 ELSE 0 END) AS net_difference
FROM content_items
WHERE STRFTIME('%Y', publish_date) IN ('2025', '2026')
GROUP BY creator_id
ORDER BY net_difference DESC, creator_id ASC
