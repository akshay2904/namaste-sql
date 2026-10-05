-- ======================================================================
-- Average Search Endpoint Latency
-- ======================================================================
-- Difficulty : Easy
-- Company    : Forbes
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_search_endpoint_latency
-- ======================================================================

/*
Autocomplete feels sluggish and the frontend team suspects the search backend is the bottleneck. What is the average latency for API calls hitting the '/api/v1/search' endpoint?

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['avg_latency']:
  [347.89294117647063]
*/


-- Write your SQL solution below:

SELECT AVG(latency) AS avg_latency
FROM api_calls
WHERE endpoint = '/api/v1/search'
