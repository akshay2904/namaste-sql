-- ======================================================================
-- Last Server Activity
-- ======================================================================
-- Difficulty : Easy
-- Company    : DoorDash
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/last_server_activity
-- ======================================================================

/*
The SRE team wants to spot servers that may have gone silent. Show each server and its most recent log timestamp, with the most recently active server first.

Table: server_logs(log_id, server_name, log_level, message, response_time_ms, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['server_name', 'last_activity']:
  ['cache-01', '2026-12-28 11:41:59']
  ['web-prod-02', '2026-12-24 23:41:59']
  ['api-prod-02', '2026-12-20 23:29:11']
  ['db-replica-01', '2026-12-16 23:17:23']
  ['worker-01', '2026-12-12 23:05:35']
*/


-- Write your SQL solution below:

SELECT server_name, MAX(log_timestamp) AS last_activity
FROM server_logs
GROUP BY server_name
ORDER BY last_activity DESC
