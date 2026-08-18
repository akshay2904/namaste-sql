-- ======================================================================
-- Endpoint Ranking
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/endpoint_ranking
-- ======================================================================

/*
The SRE team wants the slowest endpoints surfaced for a performance review. For each endpoint in api_calls, count its calls and compute its average latency, skipping rows where latency is NULL. Then rank endpoints by average latency, slowest first, with ties sharing a position. Return the endpoint, call count, average latency, and position.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'call_count', 'avg_latency', 'position']:
  ['/api/v1/search', 86, 347.89294117647063, 1]
  ['/api/v1/auth/logout', 55, 342.712962962963, 2]
  ['/api/v1/payments', 12, 316.21666666666664, 3]
  ['/api/v1/auth/login', 74, 309.6337837837838, 4]
  ['/api/v1/orders', 133, 301.90751879699246, 5]
*/


-- Write your SQL solution below:

WITH endpoint_stats AS (
    SELECT endpoint,
           COUNT(*) AS call_count,
           AVG(latency) AS avg_latency
    FROM api_calls
    GROUP BY endpoint
)
SELECT endpoint,
       call_count,
       avg_latency,
       RANK() OVER (ORDER BY avg_latency DESC) AS position
FROM endpoint_stats
ORDER BY position, endpoint;
