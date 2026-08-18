-- ======================================================================
-- Log Priority
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/log_priority
-- ======================================================================

/*
The on-call rotation wants a triage view of recent server activity. For each log entry that has a recorded response time, show the server name, the original log level, the response time in milliseconds, and a triage label: logs at the CRITICAL or ERROR level should be marked urgent, everything else routine. Surface the urgent entries first, and within the same triage label, arrange by response time from slowest to fastest.

Table: server_logs(log_id, server_name, log_level, message, response_time_ms, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['server_name', 'log_level', 'response_time_ms', 'triage']:
  ['web-prod-01', 'CRITICAL', 1297, 'urgent']
  ['cdn-edge-eu', 'ERROR', 1271, 'urgent']
  ['web-prod-02', 'INFO', 1310, 'routine']
  ['cdn-edge-us', 'WARN', 1258, 'routine']
  ['db-replica-01', 'DEBUG', 1219, 'routine']
*/


-- Write your SQL solution below:

SELECT server_name, log_level, response_time_ms, CASE WHEN log_level IN ('CRITICAL', 'ERROR') THEN 'urgent' ELSE 'routine' END AS triage FROM server_logs WHERE response_time_ms IS NOT NULL ORDER BY CASE WHEN log_level IN ('CRITICAL', 'ERROR') THEN 0 ELSE 1 END ASC, response_time_ms DESC
