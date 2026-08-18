-- ======================================================================
-- Latency Gap to 10th Fastest
-- ======================================================================
-- Difficulty : Medium
-- Company    : Civis Analytics
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/latency_gap_to_10th_fastest
-- ======================================================================

/*
During an SRE review, the VP of Infrastructure asked how server 'web-prod-01' compares to the 10th-fastest server by average response time. Calculate the absolute difference in their average response times. Return a single latency gap value.

Table: server_logs(log_id, server_name, log_level, message, response_time_ms, log_timestamp)

Sample data - server_logs ['log_id', 'server_name', 'log_level', 'message', 'response_time_ms', 'log_timestamp']:
  [137, 'web-prod-02', 'WARN', 'Connection timeout after 30s', 23, '2026-02-02 01:07:13']
  [174, 'api-prod-01', 'ERROR', 'Database query slow: 2.5s', None, '2026-03-03 02:14:26']
  [211, 'api-prod-02', 'DEBUG', 'Cache miss for key user_123', 49, '2026-04-04 03:21:39']
  [248, 'db-primary', 'CRITICAL', 'Memory usage at 85%', 62, '2026-05-05 04:28:52']
  [285, 'db-replica-01', 'INFO', 'SSL certificate expires in 7 days', None, '2026-06-06 05:35:05']

Expected output ['latency_gap']:
  [39]
*/


-- Write your SQL solution below:

WITH server_avg AS (
  SELECT server_name,
         AVG(response_time_ms) AS avg_rt
  FROM server_logs
  GROUP BY server_name
),
ranked AS (
  SELECT server_name,
         avg_rt,
         ROW_NUMBER() OVER (ORDER BY avg_rt ASC, server_name ASC) AS rnk
  FROM server_avg
)
SELECT ABS(
         (SELECT avg_rt FROM server_avg WHERE server_name = 'web-prod-01')
         - (SELECT avg_rt FROM ranked WHERE rnk = 10)
       ) AS latency_gap;
