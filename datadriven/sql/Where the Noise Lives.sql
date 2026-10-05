-- ======================================================================
-- Where the Noise Lives
-- ======================================================================
-- Difficulty : Easy
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/log_volume_by_day_of_week
-- ======================================================================

/*
Our on-call team is figuring out which days of the week the servers run the noisiest. Show each day's name with its log entry count, noisiest first.

Table: server_logs(log_id, server_name, log_level, message, response_time_ms, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['day_of_week', 'entry_count']:
  ['Sunday', 31]
  ['Tuesday', 30]
  ['Thursday', 28]
  ['Wednesday', 27]
  ['Monday', 26]
*/


-- Write your SQL solution below:

SELECT
    CASE
        WHEN strftime('%w', log_timestamp) = '0' THEN 'Sunday'
        WHEN strftime('%w', log_timestamp) = '1' THEN 'Monday'
        WHEN strftime('%w', log_timestamp) = '2' THEN 'Tuesday'
        WHEN strftime('%w', log_timestamp) = '3' THEN 'Wednesday'
        WHEN strftime('%w', log_timestamp) = '4' THEN 'Thursday'
        WHEN strftime('%w', log_timestamp) = '5' THEN 'Friday'
        WHEN strftime('%w', log_timestamp) = '6' THEN 'Saturday'
    END AS day_of_week,
    COUNT(*) AS entry_count
FROM server_logs
GROUP BY day_of_week
ORDER BY entry_count DESC, strftime('%w', log_timestamp)
