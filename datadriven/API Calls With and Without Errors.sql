-- ======================================================================
-- API Calls With and Without Errors
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/api_calls_with_and_without_errors
-- ======================================================================

/*
The API reliability team is triaging error rates across the platform. For each endpoint, they need a breakdown of how many calls completed cleanly versus how many produced an error message, along with the total call volume per endpoint.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'no_error_count', 'error_count', 'total_count']:
  ['/api/v1/auth/login', 66, 8, 74]
  ['/api/v1/auth/logout', 50, 5, 55]
  ['/api/v1/orders', 127, 6, 133]
  ['/api/v1/payments', 5, 7, 12]
  ['/api/v1/search', 82, 4, 86]
*/


-- Write your SQL solution below:

SELECT endpoint,
       SUM(CASE WHEN err_msg IS NULL THEN 1 ELSE 0 END) AS no_error_count,
       SUM(CASE WHEN err_msg IS NOT NULL THEN 1 ELSE 0 END) AS error_count,
       COUNT(*) AS total_count
FROM api_calls
GROUP BY endpoint
ORDER BY endpoint
