-- ======================================================================
-- The Loudest Voices
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_chat_contributors
-- ======================================================================

/*
We run a team chat platform, and the community team is building a leaderboard of its most active members, where a member's activity is every message they sent plus every reply directed at them. Surface the ten most active, busiest first.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['user_id', 'total_messages']:
  [4853, 4]
  [4756, 4]
  [4659, 4]
  [4562, 4]
  [4465, 4]
*/


-- Write your SQL solution below:

WITH user_msgs AS (
  SELECT sender_id AS user_id, COUNT(*) AS msg_count
  FROM chat_msgs
  GROUP BY sender_id
  UNION ALL
  SELECT reply_to AS user_id, COUNT(*) AS msg_count
  FROM chat_msgs
  WHERE reply_to IS NOT NULL
  GROUP BY reply_to
)
SELECT user_id, SUM(msg_count) AS total_messages
FROM user_msgs
GROUP BY user_id
ORDER BY total_messages DESC
LIMIT 10
