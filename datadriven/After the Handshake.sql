-- ======================================================================
-- After the Handshake
-- ======================================================================
-- Difficulty : Medium
-- Company    : Uber
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_update_call_latency
-- ======================================================================

/*
An API endpoint can look fast on a user's very first call and slower on everything after. Excluding each user's earliest call, find the average latency of the remaining calls for each endpoint, slowest first.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'avg_update_latency']:
  ['/api/v1/payments', 316.21666666666664]
  ['/api/v1/search', 282.93888888888887]
  ['/api/v1/users', 273.67410714285717]
  ['/api/v1/orders', 267.79237288135596]
  ['/api/v2/products', 260.93300970873787]
*/


-- Write your SQL solution below:

SELECT endpoint,
       CAST(AVG(latency) AS REAL) AS avg_update_latency
FROM (
  SELECT endpoint,
         latency,
         ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY call_time) AS rn
  FROM api_calls
) ranked
WHERE rn > 1
GROUP BY endpoint
ORDER BY avg_update_latency DESC
