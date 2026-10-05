-- ======================================================================
-- The Blind Spot
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/content_recommendation_engine
-- ======================================================================

/*
We run a content platform with a built-in team chat, and we want to surface pages a person has not opened yet but someone they talk to has. Treat two people as connected when they have both posted in the same chat channel, and for each person return the pages a connection has viewed that the person themselves never has.

Table: page_views(view_id, page_url, user_id, referrer, dur_ms, device, viewed_at)

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - page_views ['view_id', 'page_url', 'user_id', 'referrer', 'dur_ms', 'device', 'viewed_at']:
  [5053, '/products', 1555, 'amazon.com', 637, 'desktop', '2026-12-02 01:09:00']
  [5106, '/checkout', 1652, 'twitter.com', 774, 'tablet', '2026-12-03 02:18:00']
  [5159, '/profile', 1749, 'github.com', 911, 'Mobile', '2026-12-04 03:27:00']
  [5212, '/search', 1846, None, 1048, 'DESKTOP', '2026-12-05 04:36:00']
  [5265, '/about', 1943, 'reddit.com', 1185, 'mobile', '2026-12-06 05:45:00']

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['user_id', 'content_id']:
  [100, '/Home']
  [100, '/blog/intro']
  [100, '/checkout']
  [100, '/docs/api']
  [100, '/home']
*/


-- Write your SQL solution below:

WITH friends AS (
    SELECT DISTINCT cm1.sender_id AS user_id, cm2.sender_id AS friend_id
    FROM chat_msgs cm1
    INNER JOIN chat_msgs cm2
        ON cm1.channel = cm2.channel
       AND cm1.sender_id <> cm2.sender_id
),
user_views AS (
    SELECT DISTINCT user_id, page_url AS content_id
    FROM page_views
),
friend_views AS (
    SELECT DISTINCT f.user_id, uv.content_id
    FROM friends f
    INNER JOIN user_views uv ON uv.user_id = f.friend_id
)
SELECT DISTINCT fv.user_id, fv.content_id
FROM friend_views fv
LEFT JOIN user_views uv
    ON uv.user_id = fv.user_id
   AND uv.content_id = fv.content_id
WHERE uv.content_id IS NULL
ORDER BY fv.user_id, fv.content_id
