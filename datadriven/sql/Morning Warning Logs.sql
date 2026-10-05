-- ======================================================================
-- Morning Warning Logs
-- ======================================================================
-- Difficulty : Easy
-- Company    : Lyft
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/morning_warning_logs
-- ======================================================================

/*
After noticing pre-business-hours warning spikes, the SRE team wants to review every WARN-level server log entry that fired before noon. Return all fields.

Table: server_logs(log_id, server_name, log_level, message, response_time_ms, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [322, 'cache-01', 'WARN', 'Rate limit exceeded for IP 192.168.1.x', 88, '2026-07-07 06:42:18']
  [507, 'web-prod-01', 'WARN', 'Retrying request (attempt 3/5)', None, '2026-12-12 11:17:23']
  [1062, 'db-primary', 'WARN', 'Disk space low: 10% remaining', None, '2026-03-27 02:02:38']
  [1247, 'cdn-edge-eu', 'WARN', 'User authentication failed', 413, '2026-08-04 07:37:43']
*/


-- Write your SQL solution below:

SELECT log_id, server_name, log_level, message, response_time_ms, log_timestamp
FROM server_logs
WHERE log_level = 'WARN'
    AND CAST(STRFTIME('%H', log_timestamp) AS INTEGER) < 12
