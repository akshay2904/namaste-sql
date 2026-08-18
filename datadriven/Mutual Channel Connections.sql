-- ======================================================================
-- Mutual Channel Connections
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/mutual_channel_connections
-- ======================================================================

/*
Our messaging platform tracks which senders post in which channels. Find all sender IDs that appear in at least one channel where user 197 posted and also in at least one channel where user 585 posted, excluding those two users themselves.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['sender_id']:
  [391]
  [779]
  [973]
  [1167]
  [1361]
*/


-- Write your SQL solution below:

SELECT DISTINCT sender_id
FROM chat_msgs
WHERE sender_id NOT IN (197, 585)
  AND sender_id IN (SELECT sender_id FROM chat_msgs WHERE channel IN (SELECT channel FROM chat_msgs WHERE sender_id = 197))
  AND sender_id IN (SELECT sender_id FROM chat_msgs WHERE channel IN (SELECT channel FROM chat_msgs WHERE sender_id = 585))
