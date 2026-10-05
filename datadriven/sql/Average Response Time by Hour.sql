-- ======================================================================
-- Average Response Time by Hour
-- ======================================================================
-- Difficulty : Easy
-- Company    : Lyft
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_response_time_by_hour
-- ======================================================================

/*
Users in Asia-Pacific keep reporting slow page loads during their morning. To check whether the servers show a time-of-day pattern, compute the average response time for each hour of the day and present the hours in chronological order.

Table: server_logs(log_id, server_name, log_level, message, response_time_ms, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['hour_of_day', 'avg_response_time']:
  [0, 790]
  [1, 647]
  [2, None]
  [3, 673]
  [4, 686]
*/


-- Write your SQL solution below:

SELECT CAST(strftime('%H', log_timestamp) AS INTEGER) AS hour_of_day,
       AVG(response_time_ms) AS avg_response_time
FROM server_logs
GROUP BY hour_of_day
ORDER BY hour_of_day ASC;
