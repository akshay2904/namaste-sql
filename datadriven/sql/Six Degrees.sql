-- ======================================================================
-- Six Degrees
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/user_connection_score
-- ======================================================================

/*
Across the company chat history, every reply ties together two people, the sender and the person being replied to, and that tie runs both ways. For each person, count how many different people they are tied to, then turn that into a percentage of everyone who has ever sent or received a message. Show the most connected people first.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['user_id', 'unique_connections', 'connection_score']:
  [5, 1, 1.3514]
  [11, 1, 1.3514]
  [14, 1, 1.3514]
  [17, 1, 1.3514]
  [23, 1, 1.3514]
*/


-- Write your SQL solution below:

WITH edges AS (

    SELECT sender_id AS user_id, reply_to AS connected_to
    FROM chat_msgs
    WHERE reply_to IS NOT NULL AND reply_to <> sender_id
    UNION
    SELECT reply_to AS user_id, sender_id AS connected_to
    FROM chat_msgs
    WHERE reply_to IS NOT NULL AND reply_to <> sender_id
),
platform AS (

    SELECT COUNT(*) AS total_users
    FROM (
        SELECT sender_id AS u FROM chat_msgs
        UNION
        SELECT reply_to FROM chat_msgs WHERE reply_to IS NOT NULL
    )
)
SELECT
    e.user_id,
    COUNT(DISTINCT e.connected_to) AS unique_connections,
    ROUND(COUNT(DISTINCT e.connected_to) * 100.0 / p.total_users, 4) AS connection_score
FROM edges e
CROSS JOIN platform p
GROUP BY e.user_id, p.total_users
ORDER BY connection_score DESC, e.user_id;
