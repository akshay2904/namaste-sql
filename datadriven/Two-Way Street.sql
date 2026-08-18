-- ======================================================================
-- Two-Way Street
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/distinct_chat_conversations
-- ======================================================================

/*
In chat_msgs, each reply records the user who wrote it in sender_id and the user being replied to in reply_to, which is empty for messages that are not replies. Count the unique two-person conversations, where a reply from one user to another is the same conversation no matter which of the two sent it.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['conversation_count']:
  [24]
*/


-- Write your SQL solution below:

SELECT COUNT(DISTINCT MIN(sender_id, reply_to) || ',' || MAX(sender_id, reply_to)) AS conversation_count
FROM chat_msgs
WHERE reply_to IS NOT NULL
