-- ======================================================================
-- Once and Only Once
-- ======================================================================
-- Difficulty : Hard
-- Company    : LinkedIn
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/rarest_latency_value
-- ======================================================================

/*
On-call is triaging latency anomalies, where a reading that recurs is routine noise but a reading seen a single time is the real signal. For each endpoint, surface the highest such one-off latency, worst first.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'rarest_highest']:
  ['/api/v1/search', 1713.7]
  ['/api/v2/products', 1696.4]
  ['/api/v1/orders', 1679.1]
  ['/api/v1/users', 1661.8]
  ['/api/v1/auth/logout', 1644.5]
*/


-- Write your SQL solution below:

SELECT endpoint, MAX(latency) AS rarest_highest
FROM (
    SELECT endpoint, latency
    FROM api_calls
    GROUP BY endpoint, latency
    HAVING COUNT(*) = 1
) unique_vals
GROUP BY endpoint
ORDER BY rarest_highest DESC
