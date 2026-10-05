-- ======================================================================
-- Log Levels
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/log_levels
-- ======================================================================

/*
The SRE team is building a performance digest for the weekly incident review. For each log severity level, they want to know the number of entries and the average response time in milliseconds. Only include severity levels that have generated at least five log entries, and list them from the slowest average response time to the fastest.

Table: server_logs(log_id, server_name, log_level, message, response_time_ms, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['log_level', 'log_count', 'avg_response_ms']:
  ['INFO', 40, 710]
  ['CRITICAL', 40, 679.5]
  ['ERROR', 40, 671]
  ['DEBUG', 40, 649]
  ['WARN', 40, 640.5]
*/


-- Write your SQL solution below:

SELECT log_level, COUNT(*) AS log_count, AVG(response_time_ms) AS avg_response_ms FROM server_logs GROUP BY log_level HAVING COUNT(*) >= 5 ORDER BY avg_response_ms DESC, log_level ASC
