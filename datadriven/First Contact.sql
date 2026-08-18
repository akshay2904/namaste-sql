-- ======================================================================
-- First Contact
-- ======================================================================
-- Difficulty : Medium
-- Company    : Uber
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_initial_call_latency
-- ======================================================================

/*
The performance team is measuring first-impression latency: the first time each user hits a given endpoint, how long that call took. For every endpoint, report the average of those first-contact latencies, slowest endpoints first.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'avg_initial_call_latency']:
  ['/api/v1/auth/logout', 406.75]
  ['/api/v1/search', 381.6985507246377]
  ['/api/v1/auth/login', 356.1728813559322]
  ['/api/v1/payments', 276.96]
  ['/api/v2/products', 274.629]
*/


-- Write your SQL solution below:

SELECT endpoint,
       CAST(AVG(latency) AS REAL) AS avg_initial_call_latency
FROM (
  SELECT endpoint,
         latency,
         ROW_NUMBER() OVER (
           PARTITION BY user_id, endpoint
           ORDER BY call_time
         ) AS rn
  FROM api_calls
) first_calls
WHERE rn = 1
GROUP BY endpoint
ORDER BY avg_initial_call_latency DESC
