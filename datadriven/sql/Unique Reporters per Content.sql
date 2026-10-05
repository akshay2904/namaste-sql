-- ======================================================================
-- Unique Reporters per Content
-- ======================================================================
-- Difficulty : Medium
-- Company    : Netflix
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/unique_reporters_per_content
-- ======================================================================

/*
In the chat data, each message can be a reply to content. For each content reference, count unique reporters identified by combining sender and channel. Only count messages that are replies (reply_to is not null). Return the content ID and the reporter count.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['content_id', 'reporter_count']:
  [5, 1]
  [11, 1]
  [14, 1]
  [17, 1]
  [23, 1]
*/


-- Write your SQL solution below:

SELECT
    reply_to AS content_id,
    COUNT(DISTINCT sender_id || '-' || channel) AS reporter_count
FROM chat_msgs
WHERE reply_to IS NOT NULL
GROUP BY reply_to
