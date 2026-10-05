-- ======================================================================
-- Yearly Output
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/yearly_output
-- ======================================================================

/*
The editorial director is building the annual content report and wants to see publishing velocity broken down by year. For each calendar year, show the number of items published and the average duration in seconds. Exclude any items that have no publish date on file. Present the years in chronological order.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['year', 'items_published', 'avg_duration']:
  ['2022', 20, None]
  ['2023', 20, 2386.5]
  ['2024', 20, 2433.5]
  ['2025', 67, 2442.9824561403507]
  ['2026', 61, 2492.9411764705883]
*/


-- Write your SQL solution below:

SELECT
    STRFTIME('%Y', publish_date) AS year,
    COUNT(*) AS items_published,
    AVG(duration_seconds) AS avg_duration
FROM content_items
WHERE publish_date IS NOT NULL
GROUP BY STRFTIME('%Y', publish_date)
ORDER BY year
