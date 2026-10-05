-- ======================================================================
-- Timeout Warning Logs
-- ======================================================================
-- Difficulty : Easy
-- Company    : Vesta Innovations
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/timeout_warning_logs
-- ======================================================================

/*
During an incident postmortem, the on-call engineer needs all available fields for warning-level log entries where the message mentions a timeout.

Table: server_logs(log_id, server_name, log_level, message, response_time_ms, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [3652, 'cdn-edge-us', 'WARN', 'Connection timeout after 30s', 1258, '2026-01-13 00:12:48']
  [10003801, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2022-01-02 01:07:13']
  [10003896, 'cdn-edge-us', 'WARN', 'Connection timeout after 30s', 1258, '2022-12-13 00:12:48']
*/


-- Write your SQL solution below:

SELECT *
FROM server_logs
WHERE log_level = 'WARN'
  AND message LIKE '%timeout%'
