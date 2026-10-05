-- ======================================================================
-- Top Active Senders per Channel
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_active_senders_per_channel
-- ======================================================================

/*
Show the top 3 most active senders by message count in each chat channel. Ties share the same rank with no gaps, which may produce more than 3 rows per channel. Return channel, sender ID, and message count.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['channel', 'sender_id', 'msg_count']:
  ['#data-team', 391, 2]
  ['#data-team', 585, 2]
  ['#data-team', 973, 2]
  ['#data-team', 1167, 2]
  ['#data-team', 1555, 2]
*/


-- Write your SQL solution below:

WITH msg_counts AS (
    SELECT channel, sender_id, COUNT(*) AS msg_count
    FROM chat_msgs
    GROUP BY channel, sender_id
),
ranked AS (
    SELECT channel, sender_id, msg_count,
        DENSE_RANK() OVER (PARTITION BY channel ORDER BY msg_count DESC) AS rnk
    FROM msg_counts
)
SELECT channel, sender_id, msg_count
FROM ranked
WHERE rnk <= 3
ORDER BY channel, msg_count DESC, sender_id
