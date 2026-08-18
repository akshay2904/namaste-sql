-- ======================================================================
-- Top-Ranked Wines by Variety
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_ranked_wines_by_variety
-- ======================================================================

/*
The product team is looking at content that runs shorter than user 197's typical session. Take user 197's average session length, then return every content item whose duration is at or below that average. For each row, show the literal user ID 197, the content ID, and the content's duration in seconds.

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

-- NOTE: source page is inconsistent (title says "wines" but the problem text
-- and schema above are about content/session data) — likely a bug on
-- datadriven.io's side. Skipped rather than guess. See the URL above.
