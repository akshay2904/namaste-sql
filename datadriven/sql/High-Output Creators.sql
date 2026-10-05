-- ======================================================================
-- High-Output Creators
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/high_output_creators
-- ======================================================================

/*
The editorial team is evaluating high-volume creators who have produced at least an hour of total content (3,600 seconds). For each qualifying creator, show their average duration per item, sorted from longest average to shortest.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['creator_id', 'avg_duration']:
  [4465, 4525]
  [2719, 3679]
  [100, 3585]
  [4756, 3491]
  [4659, 3444]
*/


-- Write your SQL solution below:

SELECT creator_id,
       AVG(duration_seconds) AS avg_duration
FROM content_items
GROUP BY creator_id
HAVING SUM(duration_seconds) >= 3600
ORDER BY avg_duration DESC
