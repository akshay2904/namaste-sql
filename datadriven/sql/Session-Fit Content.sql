-- ======================================================================
-- Session-Fit Content
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/session_fit_content
-- ======================================================================

/*
For user 197, find content items whose duration is less than or equal to that user's average session length. Show the user ID, content ID, and content duration.

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['user_id', 'content_id', 'duration_seconds']:
  [197, 286, 154]
  [197, 329, 201]
  [197, 372, 248]
  [197, 415, 295]
  [197, 501, 389]
*/


-- Write your SQL solution below:

SELECT 197 AS user_id, ci.content_id, ci.duration_seconds
FROM content_items ci
WHERE ci.duration_seconds <= (
    SELECT AVG(session_duration_sec)
    FROM user_sessions
    WHERE user_id = 197
)
