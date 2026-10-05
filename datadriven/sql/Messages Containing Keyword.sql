-- ======================================================================
-- Messages Containing Keyword
-- ======================================================================
-- Difficulty : Easy
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/messages_containing_keyword
-- ======================================================================

/*
The on-call team is searching chat history for latency-related discussions during a recent incident. Pull all fields for messages that contain the word 'latency'.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [711, '#engineering', 1361, 'Anyone seeing increased latency?', 'FILE', '2026-02-14 13:31:00', 0, None]
  [1275, '#engineering', 2525, 'Anyone seeing increased latency?', 'system', '2026-02-26 01:55:00', 0, None]
  [1839, '#engineering', 3689, 'Anyone seeing increased latency?', 'reaction', '2026-02-10 13:19:00', 0, None]
  [2403, '#engineering', 4853, 'Anyone seeing increased latency?', 'text', '2026-02-22 01:43:00', 0, None]
*/


-- Write your SQL solution below:

SELECT msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to
FROM chat_msgs
WHERE content LIKE '%latency%'
