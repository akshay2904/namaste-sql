-- ======================================================================
-- Messages From Specific Users
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/messages_from_specific_users
-- ======================================================================

/*
The trust and safety team received a complaint about users 2 and 3. Pull all chat messages where either user sent the message, or where the content mentions their user IDs.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [617, '#data-team', 1167, 'Rolling back to v2.0', 'system', '2026-12-12 11:17:00', 0, None]
  [664, '#general', 1264, 'Deploying v2.1 to prod', 'Text', '2026-01-13 12:24:00', 1, 11]
  [758, '#incidents', 1458, 'PR #412 ready for review', 'text', '2026-03-15 14:38:00', 0, None]
  [1181, '#data-team', 2331, 'Rolling back to v2.0', 'reaction', '2026-12-24 23:41:00', 0, None]
*/


-- Write your SQL solution below:

SELECT msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to
FROM chat_msgs
WHERE sender_id IN (2, 3)
    OR content LIKE '%2%'
    OR content LIKE '%3%'
