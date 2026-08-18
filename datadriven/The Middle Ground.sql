-- ======================================================================
-- The Middle Ground
-- ======================================================================
-- Difficulty : Medium
-- Company    : Uber
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/sum_excluding_extremes
-- ======================================================================

/*
Given a set of latency values, sum everything that falls strictly between the global minimum and maximum, excluding the extremes themselves. Return the min, the max, and the sum of everything in between.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['min_latency', 'max_latency', 'sum_between']:
  [1, 1713.7, 197499.4]
*/


-- Write your SQL solution below:

SELECT (SELECT MIN(latency) FROM api_calls) AS min_latency, (SELECT MAX(latency) FROM api_calls) AS max_latency, SUM(latency) AS sum_between
FROM api_calls
WHERE latency > (SELECT MIN(latency) FROM api_calls) AND latency < (SELECT MAX(latency) FROM api_calls)
