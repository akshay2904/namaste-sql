-- ======================================================================
-- The Long Tail
-- ======================================================================
-- Difficulty : Hard
-- Company    : Vesta Innovations
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/latency_quartiles_per_endpoint
-- ======================================================================

/*
We're running a latency review across the API and want to see how each endpoint's response times spread out rather than collapse into a single average. Split every endpoint's calls into four equal-sized tiers running from fastest to slowest, and for each endpoint-tier report the fastest, slowest, and average latency, skipping any call that has no recorded latency.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'bucket', 'min_latency', 'max_latency', 'avg_latency']:
  ['/api/v1/auth/login', 1, 10, 95.2, 56.1]
  ['/api/v1/auth/login', 2, 102.3, 194.6, 145.88947368421054]
  ['/api/v1/auth/login', 3, 200.3, 294, 247.7555555555556]
  ['/api/v1/auth/login', 4, 301.1, 1627.2, 811.9722222222222]
  ['/api/v1/auth/logout', 1, 10, 87.5, 47.357142857142854]
*/


-- Write your SQL solution below:

WITH tiered AS (
    SELECT endpoint,
           latency,
           NTILE(4) OVER (PARTITION BY endpoint ORDER BY latency) AS bucket
    FROM api_calls
    WHERE latency IS NOT NULL
)
SELECT endpoint,
       bucket,
       MIN(latency) AS min_latency,
       MAX(latency) AS max_latency,
       AVG(latency) AS avg_latency
FROM tiered
GROUP BY endpoint, bucket
ORDER BY endpoint, bucket
