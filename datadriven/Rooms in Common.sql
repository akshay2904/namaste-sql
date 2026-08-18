-- ======================================================================
-- Rooms in Common
-- ======================================================================
-- Difficulty : Hard
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/shared_channel_contacts
-- ======================================================================

/*
We map user networks through our chat channels: two people count as connected the moment they've both posted in the same channel, no matter how many channels they end up sharing. For each sender, find how many other people they're connected to, most-connected first.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['sender_id', 'mutual_connections']:
  [4853, 24]
  [4756, 24]
  [4659, 24]
  [4562, 24]
  [4465, 24]
*/


-- Write your SQL solution below:

SELECT a.sender_id, COUNT(DISTINCT b.sender_id) AS mutual_connections
FROM chat_msgs a
INNER JOIN chat_msgs b ON a.channel = b.channel AND a.sender_id != b.sender_id
GROUP BY a.sender_id
ORDER BY mutual_connections DESC
