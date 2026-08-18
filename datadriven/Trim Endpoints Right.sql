-- ======================================================================
-- Trim Endpoints Right
-- ======================================================================
-- Difficulty : Easy
-- Company    : Stripe
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/trim_endpoints_right
-- ======================================================================

/*
A data quality check flagged trailing whitespace in endpoint names. Clean it up by returning each endpoint with trailing spaces removed, by call ID.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['call_id', 'endpoint']:
  [8079, '/api/v1/orders']
  [8158, '/api/v2/products']
  [8237, '/api/v1/search']
  [8316, '/api/v1/auth/login']
  [8395, '/api/v1/auth/logout']
*/


-- Write your SQL solution below:

SELECT call_id, RTRIM(endpoint) AS endpoint
FROM api_calls
