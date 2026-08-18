-- ======================================================================
-- Fastest Regions by Latency
-- ======================================================================
-- Difficulty : Medium
-- Company    : EY
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/fastest_regions_by_latency
-- ======================================================================

/*
The API performance team wants to highlight the fastest endpoints. Find the top 3 endpoints with the lowest average latency, including all ties at the third position. Return the endpoint and its average latency.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'avg_latency']:
  ['/api/v2/analytics', 148.0193548387097]
  ['/api/v1/users/', 164.225]
  ['/api/v2/products/', 165.94285714285715]
*/


-- Write your SQL solution below:

SELECT endpoint, avg_latency FROM (SELECT endpoint, AVG(latency) AS avg_latency, DENSE_RANK() OVER (ORDER BY AVG(latency) ASC) AS rnk FROM api_calls GROUP BY endpoint) ranked WHERE rnk <= 3
