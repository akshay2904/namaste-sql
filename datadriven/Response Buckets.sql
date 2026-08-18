-- ======================================================================
-- Response Buckets
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/response_buckets
-- ======================================================================

/*
The performance team wants API calls bucketed by latency. For each row in api_calls with a non-NULL latency, label it 'fast' when latency is under 100, 'normal' when latency is between 100 and 500 inclusive, and 'slow' when latency is above 500. Return the endpoint, latency, and that label.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'latency', "CASE WHEN latency < 100 THEN 'fast' WHEN latency <= 500 THEN 'normal' ELSE 'slow' END"]:
  ['/api/v1/orders', 4.2, 'fast']
  ['/api/v2/products', 7.9, 'fast']
  ['/api/v1/payments', 100.4, 'normal']
  ['/api/v1/users/', 104.1, 'normal']
  ['/api/v1/payments', 1200, 'slow']
*/


-- Write your SQL solution below:

SELECT endpoint, latency, CASE WHEN latency < 100 THEN 'fast' WHEN latency <= 500 THEN 'normal' ELSE 'slow' END
FROM api_calls
WHERE latency IS NOT NULL
