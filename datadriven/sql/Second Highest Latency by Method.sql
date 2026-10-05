-- ======================================================================
-- Second Highest Latency by Method
-- ======================================================================
-- Difficulty : Medium
-- Company    : KPMG
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/second_highest_latency_by_method
-- ======================================================================

/*
Find the second-highest latency API endpoint in each HTTP method group. If multiple endpoints share the highest latency, the second-highest is the next unique latency value below that. Show method, endpoint, and latency.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['method', 'endpoint', 'latency']:
  ['DELETE', '/api/v1/search', 1506.1]
  ['GET', '/api/v1/orders', 1575.3]
  ['PATCH', '/api/v1/auth/login', 1523.4]
  ['POST', '/api/v2/products', 1592.6]
  ['PUT', '/api/v2/products', 1488.8]
*/


-- Write your SQL solution below:

WITH ranked AS (
    SELECT method, endpoint, latency, DENSE_RANK() OVER (PARTITION BY method ORDER BY latency DESC) AS rnk
    FROM api_calls
)
SELECT method, endpoint, latency
FROM ranked
WHERE rnk = 2
