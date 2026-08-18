-- ======================================================================
-- Top Pattern Matches
-- ======================================================================
-- Difficulty : Medium
-- Company    : Merilytics
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_pattern_matches
-- ======================================================================

/*
Our server logs contain messages with embedded reference numbers. Find the 10 servers whose log messages most frequently match a pattern of a 3-digit prefix, a dash, then 4 or more digits. Return server_name and match count, from highest first.

Table: server_logs(log_id, server_name, message, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['server_name', 'match_count']:
  ['db-primary', 6]
  ['cache-01', 6]
  ['worker-01', 4]
  ['web-prod-02', 4]
  ['web-prod-01', 2]
*/


-- Write your SQL solution below:

SELECT server_name, COUNT(*) AS match_count
FROM server_logs
WHERE message LIKE '%___-____%'
GROUP BY server_name
ORDER BY match_count DESC
LIMIT 10
