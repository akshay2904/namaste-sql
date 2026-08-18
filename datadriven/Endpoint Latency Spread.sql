-- ======================================================================
-- Endpoint Latency Spread
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/endpoint_latency_spread
-- ======================================================================

/*
Our API monitoring tracks latency per endpoint. For each endpoint, surface the gap between the highest and lowest observed latency, the ratio of highest to lowest, and both extreme values. Exclude any entries with zero latency, and rank by the ratio from highest to lowest.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'latency_diff', 'latency_ratio', 'max_latency', 'min_latency']:
  ['/api/v1/users', 1660.8, 1661.8, 1661.8, 1]
  ['/api/v1/orders', 1674.8999999999999, 399.7857142857142, 1679.1, 4.2]
  ['/api/v2/products', 1688.5, 214.73417721518987, 1696.4, 7.9]
  ['/api/v1/search', 1703.7, 171.37, 1713.7, 10]
  ['/api/v1/auth/logout', 1634.5, 164.45, 1644.5, 10]
*/


-- Write your SQL solution below:

SELECT endpoint,
       MAX(latency) - MIN(latency) AS latency_diff,
       CAST(MAX(latency) AS REAL) / MIN(latency) AS latency_ratio,
       MAX(latency) AS max_latency,
       MIN(latency) AS min_latency
FROM api_calls
WHERE latency > 0
GROUP BY endpoint
ORDER BY latency_ratio DESC, endpoint
