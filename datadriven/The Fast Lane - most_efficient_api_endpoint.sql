-- ======================================================================
-- The Fast Lane
-- ======================================================================
-- Difficulty : Medium
-- Company    : General Assembly
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/most_efficient_api_endpoint
-- ======================================================================

/*
We score an API endpoint's efficiency as its successful calls (status 200) divided by its average latency, so an endpoint that returns more good responses for less waiting scores higher. For every endpoint with at least 5 calls, return its call count, average latency, and efficiency, most efficient first.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'call_count', 'avg_latency', 'efficiency_ratio']:
  ['/api/v1/users', 135, 293.58740740740745, 0.3951123143337967]
  ['/api/v1/orders', 133, 301.90751879699246, 0.37428680295962763]
  ['/api/v2/products', 126, 300.6176, 0.3559339173754298]
  ['/api/v1/search', 86, 347.89294117647063, 0.18971353594242987]
  ['/api/v1/auth/login', 74, 309.6337837837838, 0.16471070881468516]
*/


-- Write your SQL solution below:

SELECT endpoint,
       COUNT(*) AS call_count,
       AVG(latency) AS avg_latency,
       CAST(SUM(CASE WHEN status = 200 THEN 1 ELSE 0 END) AS REAL) / AVG(latency) AS efficiency_ratio
FROM api_calls
GROUP BY endpoint
HAVING COUNT(*) >= 5
ORDER BY efficiency_ratio DESC, endpoint
