-- ======================================================================
-- Custom Message Type Counts
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/custom_message_type_counts
-- ======================================================================

/*
The trust and safety team is tracking custom message types sent to users. Count how many times each user was on the receiving end of a message with a non-standard type (anything other than 'text' or 'image'). Show each recipient, message type, and count.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['recipient_id', 'msg_type', 'msg_count']:
  [5, 'file', 2]
  [11, 'Text', 2]
  [14, 'reaction', 2]
  [17, 'FILE', 2]
  [23, 'thread_reply', 2]
*/


-- Write your SQL solution below:

SELECT
    reply_to AS recipient_id,
    msg_type,
    COUNT(*) AS msg_count
FROM chat_msgs
WHERE msg_type NOT IN ('text', 'image')
  AND reply_to IS NOT NULL
GROUP BY reply_to, msg_type
