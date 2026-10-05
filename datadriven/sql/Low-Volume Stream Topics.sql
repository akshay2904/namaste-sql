-- ======================================================================
-- Low-Volume Stream Topics
-- ======================================================================
-- Difficulty : Medium
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/low_volume_stream_topics
-- ======================================================================

/*
The streaming platform has some low-traffic topics that might be candidates for compaction. Find topics with fewer than 11 messages, showing the topic and its message count.

Table: stream_msgs(msg_id, topic, part_key, payload, offset, produced, consumer)

Sample data - stream_msgs ['msg_id', 'topic', 'part_key', 'payload', 'offset', 'produced', 'consumer']:
  [10079, 'order-updates', 'key-3', '{"event": "type_1", "ts": 1700003600, "data": {"id": 1}}', 100, '2026-02-02 01:07:13', 'search-indexer']
  [10158, 'page-views', 'key-6', '{"event": "type_2", "ts": 1700007200, "data": {"id": 2}}', 200, '2026-03-03 02:14:26', 'ml-pipeline']
  [10237, 'click-stream', 'key-9', '{"event": "type_3", "ts": 1700010800, "data": {"id": 3}}', 300, '2026-04-04 03:21:39', 'reporting-svc']
  [10316, 'payment-events', 'key-12', '{"event": "type_4", "ts": 1700014400, "data": {"id": 4}}', 400, '2026-05-05 04:28:52', None]
  [10395, 'inventory-sync', 'key-15', '{"event": "type_5", "ts": 1700018000, "data": {"id": 5}}', 500, '2026-06-06 05:35:05', 'notification-svc']

Expected output ['topic', 'msg_count']:
  ['Han Washington', 4]
  ['Isa Butler', 4]
  ['Joy Simmons', 4]
  ['Ada Jenkins', 6]
  ['Bob Perry', 6]
*/


-- Write your SQL solution below:

SELECT topic, COUNT(*) AS msg_count
FROM stream_msgs
GROUP BY topic
HAVING COUNT(*) < 11
ORDER BY msg_count ASC, topic ASC
