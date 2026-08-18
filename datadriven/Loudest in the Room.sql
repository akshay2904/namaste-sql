-- ======================================================================
-- Loudest in the Room
-- ======================================================================
-- Difficulty : Medium
-- Company    : DoorDash
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/daily_top_endpoints
-- ======================================================================

/*
An operations dashboard spotlights the busiest API endpoints each day. For every day, surface the endpoints whose daily call count is among the three highest counts that day, and report the day, the endpoint, and its level (1 for the busiest count, 3 for the third highest), earliest day first.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['call_day', 'endpoint', 'rnk']:
  ['2023-01-01', '/api/v1/users', 1]
  ['2023-01-12', '/api/v1/auth/logout', 1]
  ['2026-02-01', '/api/v1/search', 2]
  ['2026-02-01', '/api/v1/auth/login', 3]
  ['2026-02-02', '/api/v1/users', 2]
*/


-- Write your SQL solution below:

WITH ranked AS (
  SELECT DATE(call_time) AS call_day,
         endpoint,
         COUNT(*) AS call_count,
         DENSE_RANK() OVER (PARTITION BY DATE(call_time) ORDER BY COUNT(*) DESC) AS rnk
  FROM api_calls
  GROUP BY DATE(call_time), endpoint
)
SELECT call_day, endpoint, rnk
FROM ranked
WHERE rnk <= 3
ORDER BY call_day ASC, rnk ASC, endpoint ASC
