-- ======================================================================
-- Threads Excluding User
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/threads_excluding_user
-- ======================================================================

/*
The trust and safety team needs to audit messaging activity that doesn't involve user 1. A thread is defined as a unique sender_id and reply_to pair. Count how many threads exist where neither the sender_id nor the reply_to is user 1, considering only messages that have a non-null reply_to.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['thread_count']:
  [24]
*/


-- Write your SQL solution below:

SELECT COUNT(DISTINCT sender_id || '-' || reply_to) AS thread_count
FROM chat_msgs
WHERE sender_id != 1 AND reply_to != 1
  AND reply_to IS NOT NULL
