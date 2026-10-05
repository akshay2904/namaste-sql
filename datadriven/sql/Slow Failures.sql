-- ======================================================================
-- Slow Failures
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/slow_failures
-- ======================================================================

/*
The SRE team is investigating timeout-related incidents and needs to find API calls that both failed and took an unusually long time. Pull the endpoint, HTTP status code, latency, and the error message for every call that returned a client or server error and had a latency above two hundred milliseconds. Show the slowest failures first.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'status', 'latency', 'err_msg']:
  ['/api/v1/search', 403, 1713.7, None]
  ['/api/v2/products', 401, 1696.4, None]
  ['/api/v1/orders', 400, 1679.1, None]
  ['/api/v1/users', 503, 1558, None]
  ['/api/v1/auth/logout', 502, 1540.7, None]
*/


-- Write your SQL solution below:

SELECT endpoint, status, latency, err_msg
FROM api_calls
WHERE status >= 400 AND latency > 200
ORDER BY latency DESC
