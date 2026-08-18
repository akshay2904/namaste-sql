-- ======================================================================
-- The Words That Page Us
-- ======================================================================
-- Difficulty : Hard
-- Company    : Yelp
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/incident_keyword_messages
-- ======================================================================

/*
During an incident review, on-call wants every chat message mentioning 'latency', 'down', 'back', or 'pipeline' lined up against the error tracking entries logged in the same month. Show the channel, the message text, and the severity of the error it matched.

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Table: err_tracks(err_id, err_type, message, svc_name, severity, count, first_at)

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Sample data - err_tracks ['err_id', 'err_type', 'message', 'svc_name', 'severity', 'count', 'first_at']:
  [137, 'TypeError', 'Cannot read property of undefined', 'payment-api', 'error', 8, '2026-02-02 01:11:00']
  [174, 'ConnectionTimeout', 'Connection timed out after 30s', 'user-svc', 'warning', 15, '2026-03-03 02:22:00']
  [211, 'OutOfMemory', 'Heap space exhausted', 'search-api', 'info', 22, '2026-04-04 03:33:00']
  [248, 'FileNotFound', 'File /tmp/data.csv not found', 'gateway', 'Fatal', 29, '2026-05-05 04:44:00']
  [285, 'PermissionDenied', 'Access denied for user root', 'worker', 'ERROR', 36, '2026-06-06 05:55:00']

Expected output ['channel', 'content', 'severity']:
  ['#engineering', 'Anyone seeing increased latency?', 'error']
  ['#engineering', 'Anyone seeing increased latency?', 'error']
  ['#random', 'Dashboard is down', 'info']
  ['#deployments', 'Can someone check the pipeline?', 'Fatal']
  ['#data-team', 'Rolling back to v2.0', 'ERROR']
*/


-- Write your SQL solution below:

SELECT cm.channel, cm.content, et.severity
FROM chat_msgs cm
INNER JOIN err_tracks et
  ON SUBSTR(cm.sent_at, 1, 7) = SUBSTR(et.first_at, 1, 7)
WHERE cm.content LIKE '%latency%'
   OR cm.content LIKE '%down%'
   OR cm.content LIKE '%back%'
   OR cm.content LIKE '%pipeline%'
