-- ======================================================================
-- Log Entries by Level
-- ======================================================================
-- Difficulty : Easy
-- Company    : Yelp
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/log_entries_by_level
-- ======================================================================

/*
The SRE dashboard needs a count of server log entries at each log level, alphabetically by level.

Table: server_logs(log_id, server_name, log_level, message, response_time_ms, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['log_level', 'entry_count']:
  ['CRITICAL', 40]
  ['DEBUG', 40]
  ['ERROR', 40]
  ['INFO', 40]
  ['WARN', 40]
*/


-- Write your SQL solution below:

SELECT log_level, COUNT(*) AS entry_count
FROM server_logs
GROUP BY log_level
ORDER BY log_level ASC
