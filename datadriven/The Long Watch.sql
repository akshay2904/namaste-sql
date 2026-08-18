-- ======================================================================
-- The Long Watch
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/creators_with_top_rated_content
-- ======================================================================

/*
A media team is auditing its content library, where articles carry no runtime while videos, podcasts, and other formats do. For each content type, report how many items were published and the average runtime of that format, longest-running formats first.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['content_type', 'items_published', 'avg_runtime']:
  ['video', 40, 2527.5]
  ['livestream', 40, 2480.5]
  ['short', 40, 2433.5]
  ['podcast', 40, 2386.5]
  ['article', 40, None]
*/


-- Write your SQL solution below:

SELECT
    content_type,
    COUNT(*) AS items_published,
    AVG(duration_seconds) AS avg_runtime
FROM content_items
GROUP BY content_type
ORDER BY avg_runtime DESC;
