-- ======================================================================
-- The Ones Worth Paging
-- ======================================================================
-- Difficulty : Hard
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/exact_keyword_counts_in_logs
-- ======================================================================

/*
The SRE team is building a triage chart covering the three severity levels that call for action: CRITICAL, ERROR, and WARN. Show each of these levels alongside the total number of log entries recorded for it.

Table: server_logs(log_id, server_name, log_level, message, response_time_ms, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['log_level', 'total_count']:
  ['CRITICAL', 40]
  ['ERROR', 40]
  ['WARN', 40]
*/


-- Write your SQL solution below:

SELECT log_level, COUNT(*) AS total_count
FROM server_logs
WHERE log_level IN ('CRITICAL', 'ERROR', 'WARN')
GROUP BY log_level
ORDER BY log_level
