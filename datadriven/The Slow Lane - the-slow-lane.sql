-- ======================================================================
-- The Slow Lane
-- ======================================================================
-- Difficulty : Medium
-- Company    : Slalom
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the-slow-lane
-- ======================================================================

/*
The reliability team is combing through server logs to find the machines that are dragging response times up. Give each server its average response time, then surface the ones sitting above the average machine, the mean of those per-server averages, slowest first.

Table: server_logs(log_id, server_name, log_level, message, response_time_ms, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['server_name', 'avg_response_ms']:
  ['web-prod-01', 796.5]
  ['cdn-edge-us', 757.5]
  ['db-replica-01', 718.5]
  ['cdn-edge-eu', 699]
  ['api-prod-01', 679.5]
*/


-- Write your SQL solution below:

WITH server_latency AS (
  SELECT server_name,
         AVG(response_time_ms) AS avg_response_ms
  FROM server_logs
  GROUP BY server_name
)
SELECT server_name,
       avg_response_ms
FROM server_latency
WHERE avg_response_ms > (SELECT AVG(avg_response_ms) FROM server_latency)
ORDER BY avg_response_ms DESC
