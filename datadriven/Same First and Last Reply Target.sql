-- ======================================================================
-- Same First and Last Reply Target
-- ======================================================================
-- Difficulty : Medium
-- Company    : General Assembly
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/same_first_and_last_reply_target
-- ======================================================================

/*
Something odd turned up in messaging analytics. Find users whose first and last message in a channel on the same day were sent to the same recipient. Show the sender, recipient, and the date.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['sender_id', 'reply_to', 'msg_date']:
  [100, 98, '2026-04-17']
  [100, 98, '2026-05-17']
  [294, 50, '2023-04-25']
  [294, 50, '2026-05-25']
  [682, 53, '2022-08-01']
*/


-- Write your SQL solution below:

SELECT DISTINCT sender_id, reply_to, msg_date
FROM (
  SELECT sender_id, channel, substr(sent_at, 1, 10) AS msg_date, reply_to,
    FIRST_VALUE(reply_to) OVER (PARTITION BY sender_id, channel, substr(sent_at, 1, 10) ORDER BY sent_at ASC) AS first_reply,
    LAST_VALUE(reply_to) OVER (PARTITION BY sender_id, channel, substr(sent_at, 1, 10) ORDER BY sent_at ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_reply
  FROM chat_msgs
  WHERE reply_to IS NOT NULL
)
WHERE first_reply = last_reply
ORDER BY sender_id, msg_date
