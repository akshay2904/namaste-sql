-- ======================================================================
-- The Slow Lane
-- ======================================================================
-- Difficulty : Easy
-- Company    : Spotify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/overall_average_api_latency
-- ======================================================================

/*
The SLO team is auditing platform latency and wants each endpoint's average latency, slowest first.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'avg_latency']:
  ['/api/v1/search', 347.89294117647063]
  ['/api/v1/auth/logout', 342.712962962963]
  ['/api/v1/payments', 316.21666666666664]
  ['/api/v1/auth/login', 309.6337837837838]
  ['/api/v1/orders', 301.90751879699246]
*/


-- Write your SQL solution below:

SELECT endpoint, AVG(latency) AS avg_latency
FROM api_calls
GROUP BY endpoint
ORDER BY avg_latency DESC
