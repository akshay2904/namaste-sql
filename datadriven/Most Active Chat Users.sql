-- ======================================================================
-- Most Active Chat Users
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/most_active_chat_users
-- ======================================================================

/*
Rank all chat users by total message volume so that tied counts share the same rank with no gaps. Show each user's rank, ID, and total messages, from most to least active.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['rnk', 'sender_id', 'total_messages']:
  [1, 4853, 4]
  [1, 4756, 4]
  [1, 4659, 4]
  [1, 4562, 4]
  [1, 4465, 4]
*/


-- Write your SQL solution below:

SELECT DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk,
    sender_id,
    COUNT(*) AS total_messages
FROM chat_msgs
GROUP BY sender_id
ORDER BY rnk
