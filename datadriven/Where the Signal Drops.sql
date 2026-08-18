-- ======================================================================
-- Where the Signal Drops
-- ======================================================================
-- Difficulty : Medium
-- Company    : Verizon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/where-the-signal-drops
-- ======================================================================

/*
On-call has been tracking API reliability and wants to know which endpoints are failing most often. Look only at endpoints with at least 20 calls, and for each one report its share of error responses (a 4xx or 5xx status), worst first.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'total_calls', 'error_calls', 'error_rate']:
  ['/api/v1/auth/logout', 55, 13, 23.64]
  ['/api/v2/analytics', 32, 7, 21.88]
  ['/api/v1/auth/login', 74, 16, 21.62]
  ['/api/v1/orders', 133, 15, 11.28]
  ['/api/v2/products', 126, 14, 11.11]
*/


-- Write your SQL solution below:

SELECT endpoint,
       COUNT(*) AS total_calls,
       SUM(CASE WHEN status >= 400 THEN 1 ELSE 0 END) AS error_calls,
       ROUND(100.0 * SUM(CASE WHEN status >= 400 THEN 1 ELSE 0 END) / COUNT(*), 2) AS error_rate
FROM api_calls
GROUP BY endpoint
HAVING COUNT(*) >= 20
ORDER BY error_rate DESC, endpoint
