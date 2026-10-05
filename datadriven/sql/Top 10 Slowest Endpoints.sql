-- ======================================================================
-- Top 10 Slowest Endpoints
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_10_slowest_endpoints
-- ======================================================================

/*
For the quarterly performance review, rank endpoints by their peak single-request latency in 2025. Ties should share the same rank. Include all endpoints ranked in the top 10, even if ties push the count beyond 10, and show the endpoint with its peak latency.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'max_latency', 'rnk']:
  ['/api/v1/search', 1713.7, 1]
  ['/api/v2/products', 1696.4, 2]
  ['/api/v1/orders', 1679.1, 3]
  ['/api/v1/users', 1661.8, 4]
  ['/api/v1/auth/logout', 1644.5, 5]
*/


-- Write your SQL solution below:

SELECT endpoint, max_latency, rnk FROM (
  SELECT endpoint, MAX(latency) AS max_latency,
         DENSE_RANK() OVER (ORDER BY MAX(latency) DESC) AS rnk
  FROM api_calls
  WHERE strftime('%Y', call_time) = '2026'
  GROUP BY endpoint
) ranked
WHERE rnk <= 10
ORDER BY rnk ASC, endpoint ASC
