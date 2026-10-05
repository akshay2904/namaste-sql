-- ======================================================================
-- Top Content by Lifetime Value
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_content_by_lifetime_value
-- ======================================================================

/*
The content team wants the most-watched content overall. A view counts toward a piece of content when a page view's user matches that content's creator (treat any page view by a creator as a view of all their work). Sum the page view durations to get each content item's lifetime value. Rank by lifetime value descending, allowing ties to share a rank. Return the top three ranks, with content ID, title, and lifetime value.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Table: content_views(view_id, content_id, user_id, device_id, viewed_at, watch_seconds)

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Sample data - content_views ['view_id', 'content_id', 'user_id', 'device_id', 'viewed_at', 'watch_seconds']:
  [7053, 372, 1361, 404, '2026-02-02 01:07:00', 41]
  [7106, 501, 2622, 607, '2026-03-03 02:14:00', 72]
  [7159, 630, 3883, 810, '2026-04-04 03:21:00', 103]
  [7212, 759, 5144, 1013, '2026-05-05 04:28:00', 134]
  [7265, 888, 6405, 1216, '2026-06-06 05:35:00', 165]

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Expected output ['content_id', 'title', 'lifetime_value']:
  [3124, 'Breaking Down DevOps', 142972]
  [10004568, 'Breaking Down DevOps', 142972]
  [888, 'Deep Dive: Cloud Computing', 126628]
  [3038, 'Deep Dive: Cloud Computing', 126628]
  [931, 'Behind the Scenes of Product Management', 104530]
*/


-- Write your SQL solution below:

WITH creator_views AS (
    SELECT
        c.content_id,
        c.title,
        SUM(pv.dur_ms) AS lifetime_value
    FROM content_items c
    JOIN page_views pv ON pv.user_id = c.creator_id
    GROUP BY c.content_id, c.title
),
ranked AS (
    SELECT
        content_id,
        title,
        lifetime_value,
        RANK() OVER (ORDER BY lifetime_value DESC) AS rnk
    FROM creator_views
)
SELECT content_id, title, lifetime_value
FROM ranked
WHERE rnk <= 3
ORDER BY lifetime_value DESC, content_id;
