-- ======================================================================
-- The Loudest Machines
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/most_active_servers_by_log_volume
-- ======================================================================

/*
An observability team is sizing next quarter's log storage and needs to see how the load spreads across servers. Report how many log entries each server generated during 2026, busiest first.

Table: server_logs(log_id, server_name, log_level, message, response_time_ms, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['server_name', 'log_count']:
  ['web-prod-02', 12]
  ['api-prod-01', 11]
  ['api-prod-02', 11]
  ['cache-01', 10]
  ['web-prod-01', 10]
*/


-- Write your SQL solution below:

SELECT server_name, COUNT(*) AS log_count
FROM server_logs
WHERE STRFTIME('%Y', log_timestamp) = '2026'
GROUP BY server_name
ORDER BY log_count DESC, server_name ASC
