-- ======================================================================
-- Where the Talking Stops
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/chat_activity
-- ======================================================================

/*
The community team is auditing channel health, from the busiest rooms down to the ghost towns. For each channel with at least five messages, report the total message count, how many different people posted, and what percentage of messages were later edited, busiest first.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['channel', 'total_messages', 'unique_senders', 'edited_pct']:
  ['#random', 34, 17, 0]
  ['#incidents', 34, 17, 0]
  ['#engineering', 34, 17, 0]
  ['#general', 32, 16, 50]
  ['#data-team', 32, 16, 0]
*/


-- Write your SQL solution below:

SELECT
    channel,
    COUNT(*) AS total_messages,
    COUNT(DISTINCT sender_id) AS unique_senders,
    ROUND(100.0 * SUM(CASE WHEN edited = 1 THEN 1 ELSE 0 END) / COUNT(*), 1) AS edited_pct
FROM chat_msgs
GROUP BY channel
HAVING COUNT(*) >= 5
ORDER BY total_messages DESC
