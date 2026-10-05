-- ======================================================================
-- The Freshest Record
-- ======================================================================
-- Difficulty : Medium
-- Company    : Target
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/deduplicate_and_keep_latest
-- ======================================================================

/*
The observability team is cleaning up server logs ahead of a weekly review. Same server emitting the same message multiple times should appear only once, keeping the most recent occurrence. After that, narrow the result to entries from the last 7 days. Show every column from the surviving rows.

Table: server_logs(log_id, server_name, log_level, message, response_time_ms, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [3171, 'cache-01', 'DEBUG', 'Disk space low: 10% remaining', None, '2026-12-28 11:41:59']
  [951, 'web-prod-02', 'DEBUG', 'Memory usage at 85%', None, '2026-12-24 23:41:59']
*/


-- Write your SQL solution below:

WITH ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY server_name, message
            ORDER BY log_timestamp DESC
        ) AS rn
    FROM server_logs
)
SELECT log_id, server_name, log_level, message, response_time_ms, log_timestamp
FROM ranked
WHERE rn = 1
  AND julianday(date('2026-12-28')) - julianday(log_timestamp) <= 7
ORDER BY log_timestamp DESC, log_id
