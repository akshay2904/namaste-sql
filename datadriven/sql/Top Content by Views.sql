-- ======================================================================
-- Top Content by Views
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_content_by_views
-- ======================================================================

/*
The content team wants the five most-viewed pieces. A view counts when a page view's user matches the content's creator (treat any page view by a creator as a view of their work). Rank content by that view count, allowing ties (ranks may skip). Return the title and view count for everything in the top five, biggest first, breaking ties alphabetically by title.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Expected output ['title', 'view_count']:
  ['Behind the Scenes of Product Management', 26]
  ['Behind the Scenes of Product Management', 26]
  ['Breaking Down DevOps', 26]
  ['Breaking Down DevOps', 26]
  ['Deep Dive: Cloud Computing', 26]
*/


-- Write your SQL solution below:

WITH creator_views AS (
    SELECT
        c.title,
        COUNT(pv.view_id) AS view_count
    FROM content_items c
    JOIN page_views pv ON pv.user_id = c.creator_id
    GROUP BY c.content_id, c.title
),
ranked AS (
    SELECT
        title,
        view_count,
        RANK() OVER (ORDER BY view_count DESC) AS rnk
    FROM creator_views
)
SELECT title, view_count
FROM ranked
WHERE rnk <= 5
ORDER BY view_count DESC, title ASC;
