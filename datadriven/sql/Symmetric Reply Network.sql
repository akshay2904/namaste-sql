-- ======================================================================
-- Symmetric Reply Network
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/symmetric_reply_network
-- ======================================================================

/*
The `chat_msgs` table logs team chat activity, where a reply stores the user ID of the person being replied to in `reply_to` while an original post leaves it empty. Map the symmetric reply network: whenever one person replied to another, list that pair of user IDs in both directions.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['user_a', 'user_b']:
  [5, 876]
  [11, 1264]
  [14, 1652]
  [17, 2040]
  [23, 2428]
*/


-- Write your SQL solution below:

SELECT sender_id AS user_a, reply_to AS user_b
FROM chat_msgs
WHERE reply_to IS NOT NULL UNION
SELECT reply_to AS user_a, sender_id AS user_b
FROM chat_msgs
WHERE reply_to IS NOT NULL
