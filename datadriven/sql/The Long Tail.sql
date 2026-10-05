-- ======================================================================
-- The Long Tail
-- ======================================================================
-- Difficulty : Medium
-- Company    : General Assembly
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/80th_percentile_api_latency
-- ======================================================================

/*
The performance team is hunting the latency tail on the API gateway, where the request logs record the HTTP `method` inconsistently, sometimes in lowercase. For each method, average the `latency` of its five slowest calls, and list the methods from the highest average down.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['method', 'slowest_five_avg']:
  ['POST', 1602.98]
  ['GET', 1594.84]
  ['PATCH', 1402.3]
  ['DELETE', 1385]
  ['PUT', 1367.7]
*/


-- Write your SQL solution below:

WITH ranked AS (
    SELECT
        UPPER(method) AS method,
        latency,
        ROW_NUMBER() OVER (PARTITION BY UPPER(method) ORDER BY latency DESC) AS rn
    FROM api_calls
    WHERE latency IS NOT NULL
)
SELECT
    method,
    ROUND(AVG(latency), 2) AS slowest_five_avg
FROM ranked
WHERE rn <= 5
GROUP BY method
ORDER BY slowest_five_avg DESC;
