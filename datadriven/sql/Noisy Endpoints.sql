-- ======================================================================
-- Noisy Endpoints
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/noisy_endpoints
-- ======================================================================

/*
The SRE team is triaging an incident and needs a quick view of which API endpoints are generating the most error traffic. A response code at or above 400 counts as a failure. For each endpoint that has accumulated more than two such failures, show the endpoint, the total number of failures, and the typical response time across those failed calls. List from the most failure-prone endpoint to the least.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'failure_count', 'avg_latency']:
  ['/api/v1/auth/login', 16, 516.05625]
  ['/api/v1/orders', 15, 676.26]
  ['/api/v2/products', 14, 631.9928571428571]
  ['/api/v1/users', 13, 615.5846153846153]
  ['/api/v1/search', 13, 698.2538461538461]
*/


-- Write your SQL solution below:

SELECT
    endpoint,
    COUNT(*) AS failure_count,
    AVG(latency) AS avg_latency
FROM api_calls
WHERE status >= 400
GROUP BY endpoint
HAVING COUNT(*) > 2
ORDER BY failure_count DESC
