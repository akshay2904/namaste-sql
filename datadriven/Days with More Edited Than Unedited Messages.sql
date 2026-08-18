-- ======================================================================
-- Days with More Edited Than Unedited Messages
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/days_with_more_edited_than_unedited_messages
-- ======================================================================

/*
Pull all records from days when the number of edited messages exceeded the number of unedited messages. Return all available fields for qualifying rows.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [10004836, '#general', 3592, 'Deploying v2.1 to prod', 'file', '2022-12-09 12:12:00', 1, 35]
  [10004896, '#general', 4562, 'Deploying v2.1 to prod', 'Text', '2022-12-13 00:12:00', 1, 95]
  [10004812, '#general', 1264, 'Deploying v2.1 to prod', 'Text', '2023-12-13 12:24:00', 1, 11]
  [10004872, '#general', 2234, 'Deploying v2.1 to prod', 'reaction', '2023-12-17 00:24:00', 1, 71]
  [10004848, '#general', 4756, 'Deploying v2.1 to prod', 'FILE', '2024-12-21 00:36:00', 1, 47]
*/


-- Write your SQL solution below:

WITH qualifying_days AS (
    SELECT DATE(sent_at) AS msg_date
    FROM chat_msgs
    GROUP BY DATE(sent_at)
    HAVING SUM(CASE WHEN edited = 1 THEN 1 ELSE 0 END)
         > SUM(CASE WHEN edited = 0 THEN 1 ELSE 0 END)
)
SELECT cm.*
FROM chat_msgs cm
JOIN qualifying_days qd ON DATE(cm.sent_at) = qd.msg_date
ORDER BY cm.sent_at, cm.msg_id
