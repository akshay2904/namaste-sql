-- ======================================================================
-- Content Mix
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/content_mix
-- ======================================================================

/*
The editorial team is deciding next quarter's production budget and wants to compare content formats head-to-head. For each content type, show the number of published items, the average duration in seconds, and the share of items that have no duration on file. Round the share to one decimal place and present the formats from most published to least.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['content_type', 'item_count', 'avg_duration', 'no_duration_pct']:
  ['video', 40, 2527.5, 0]
  ['short', 40, 2433.5, 0]
  ['podcast', 40, 2386.5, 0]
  ['livestream', 40, 2480.5, 0]
  ['article', 40, None, 100]
*/


-- Write your SQL solution below:

SELECT
    content_type,
    COUNT(*) AS item_count,
    AVG(duration_seconds) AS avg_duration,
    ROUND(100.0 * SUM(CASE WHEN duration_seconds IS NULL THEN 1 ELSE 0 END) / COUNT(*), 1) AS no_duration_pct
FROM content_items
GROUP BY content_type
ORDER BY item_count DESC
