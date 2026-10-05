-- ======================================================================
-- Pairwise Latency Maximum
-- ======================================================================
-- Difficulty : Medium
-- Company    : Deloitte
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/pairwise_latency_maximum
-- ======================================================================

/*
Take every combination of latency values from api_calls (with replacement) and, for each pair, show both values and whichever is larger. Limit to the first 100 rows when both values are in ascending sequence. Return the two latency values and the maximum of the pair.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['latency_1', 'latency_2', 'max_latency']:
  [1, 1, 1]
  [1, 4.2, 4.2]
  [1, 7.9, 7.9]
  [1, 10, 10]
  [1, 10, 10]
*/


-- Write your SQL solution below:

SELECT a.latency AS latency_1,
       b.latency AS latency_2,
       CASE WHEN a.latency >= b.latency THEN a.latency ELSE b.latency END AS max_latency
FROM api_calls a
CROSS JOIN api_calls b
WHERE a.latency IS NOT NULL AND b.latency IS NOT NULL
ORDER BY a.latency, b.latency
LIMIT 100
