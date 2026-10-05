-- ======================================================================
-- Endpoint Performance Report
-- ======================================================================
-- Difficulty : Medium
-- Company    : Tata Consultancy Services
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/endpoint_performance_report
-- ======================================================================

/*
Next week's reliability review needs endpoint stats. For each endpoint with at least 5 calls, surface the total call count, average latency, and the number of calls that exceeded the 500ms SLA threshold. Round to 2 decimal places.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'total_calls', 'avg_latency', 'high_latency_count']:
  ['/api/v1/users', 135, 293.59, 13]
  ['/api/v1/orders', 133, 301.91, 14]
  ['/api/v2/products', 126, 300.62, 13]
  ['/api/v1/search', 86, 347.89, 12]
  ['/api/v1/auth/login', 74, 309.63, 11]
*/


-- Write your SQL solution below:

SELECT a.endpoint,
       COUNT(*) AS total_calls,
       ROUND(AVG(a.latency), 2) AS avg_latency,
       SUM(CASE WHEN a.latency > 500 THEN 1 ELSE 0 END) AS high_latency_count
FROM api_calls a
GROUP BY a.endpoint
HAVING COUNT(*) >= 5
ORDER BY total_calls DESC, a.endpoint
