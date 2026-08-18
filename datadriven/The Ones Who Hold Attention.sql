-- ======================================================================
-- The Ones Who Hold Attention
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/avg_session_duration_by_creator
-- ======================================================================

/*
The content team is studying which creators hold viewer attention. A session counts toward a creator if the user in that session is also a creator in the content table. For each such creator, show the creator's ID and their average session length in seconds, sorted by creator ID.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Table: content_items(content_id, title, content_type, duration_seconds, creator_id, publish_date)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Sample data - content_items ['content_id', 'title', 'content_type', 'duration_seconds', 'creator_id', 'publish_date']:
  [243, 'The Ultimate Guide to AI Trends', 'article', None, 197, '2026-02-02']
  [286, 'Top 10 Mobile Apps', 'podcast', 154, 294, '2025-03-03']
  [329, 'Understanding Machine Learning', 'short', 201, 391, '2026-04-04']
  [372, 'Mastering Tech Startups', 'livestream', 248, 488, '2025-05-05']
  [415, 'Introduction to Cybersecurity', 'video', 295, 585, '2026-06-06']

Expected output ['creator_id', 'avg_session_duration']:
  [100, 3120]
  [197, 973]
  [294, 996]
  [391, 1019]
  [488, 888.6666666666666]
*/


-- Write your SQL solution below:

SELECT ci.creator_id,
       AVG(us.session_duration_sec) AS avg_session_duration
FROM user_sessions us
INNER JOIN content_items ci
       ON us.user_id = ci.creator_id
GROUP BY ci.creator_id
ORDER BY ci.creator_id;
