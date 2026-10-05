-- ======================================================================
-- Alert Severity
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/alert_severity
-- ======================================================================

/*
The streaming infrastructure team is analyzing message ordering within each topic. For each message, show its offset, the previous message's offset within the same topic, its dense rank by offset within the topic, and its sequential row number within the topic. Only include messages that have a predecessor in the same topic.

Table: stream_msgs(msg_id, topic, part_key, payload, offset, produced, consumer)

Sample data - stream_msgs ['msg_id', 'topic', 'part_key', 'payload', 'offset', 'produced', 'consumer']:
  [10079, 'order-updates', 'key-3', '{"event": "type_1", "ts": 1700003600, "data": {"id": 1}}', 100, '2026-02-02 01:07:13', 'search-indexer']
  [10158, 'page-views', 'key-6', '{"event": "type_2", "ts": 1700007200, "data": {"id": 2}}', 200, '2026-03-03 02:14:26', 'ml-pipeline']
  [10237, 'click-stream', 'key-9', '{"event": "type_3", "ts": 1700010800, "data": {"id": 3}}', 300, '2026-04-04 03:21:39', 'reporting-svc']
  [10316, 'payment-events', 'key-12', '{"event": "type_4", "ts": 1700014400, "data": {"id": 4}}', 400, '2026-05-05 04:28:52', None]
  [10395, 'inventory-sync', 'key-15', '{"event": "type_5", "ts": 1700018000, "data": {"id": 5}}', 500, '2026-06-06 05:35:05', 'notification-svc']

Expected output ['topic', 'offset', 'prev_offset', 'msg_rank', 'msg_row_num']:
  ['Ada Jenkins', 1400, 1400, 1, 2]
  ['Ada Jenkins', 5400, 1400, 2, 3]
  ['Ada Jenkins', 5400, 5400, 2, 4]
  ['Ada Jenkins', 9400, 5400, 3, 5]
  ['Bob Perry', 1500, 1500, 1, 2]
*/


-- Write your SQL solution below:

SELECT topic, offset, prev_offset, msg_rank, msg_row_num FROM (
  SELECT topic, offset,
    LAG(offset) OVER (PARTITION BY topic ORDER BY CAST(offset AS INTEGER)) AS prev_offset,
    DENSE_RANK() OVER (PARTITION BY topic ORDER BY CAST(offset AS INTEGER)) AS msg_rank,
    ROW_NUMBER() OVER (PARTITION BY topic ORDER BY CAST(offset AS INTEGER)) AS msg_row_num
  FROM stream_msgs
)
WHERE prev_offset IS NOT NULL
