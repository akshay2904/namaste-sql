-- ======================================================================
-- Server With Most Errors
-- ======================================================================
-- Difficulty : Medium
-- Company    : Spotify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/server_with_most_errors
-- ======================================================================

/*
During an incident, the on-call SRE needs to find the single server with the most logged errors. Show the server name and its error count.

Table: server_logs(log_id, server_name, log_level, message, response_time_ms, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['server_name', 'error_count']:
  ['worker-01', 4]
*/


-- Write your SQL solution below:

SELECT server_name, COUNT(*) AS error_count
FROM server_logs
WHERE log_level = 'ERROR'
GROUP BY server_name
ORDER BY error_count DESC
LIMIT 1
