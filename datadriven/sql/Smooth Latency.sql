-- ======================================================================
-- Smooth Latency
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/smooth_latency
-- ======================================================================

/*
Some of our API endpoints look like they are drifting slower as traffic grows, and we want the underlying trend rather than the per-call noise. For each endpoint, walk its calls from oldest to newest (breaking ties by call_id) and, at each call, report the average latency across that call and every earlier one, skipping any call with no recorded latency.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'latency', 'running_avg']:
  ['/api/v1/auth/login', 381.6, 381.6]
  ['/api/v1/auth/login', 70.2, 225.9]
  ['/api/v1/auth/login', 277.8, 243.20000000000002]
  ['/api/v1/auth/logout', 191.3, 191.3]
  ['/api/v1/auth/logout', 398.9, 295.1]
*/


-- Write your SQL solution below:

SELECT
    endpoint,
    latency,
    AVG(latency) OVER (
        PARTITION BY endpoint
        ORDER BY call_time, call_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_avg
FROM api_calls
WHERE latency IS NOT NULL
