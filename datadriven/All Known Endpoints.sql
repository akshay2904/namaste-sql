-- ======================================================================
-- All Known Endpoints
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/all_known_endpoints
-- ======================================================================

/*
The platform team is assembling a service catalog of every endpoint that shows up in either the API request logs or the rate limit rules. Some paths were recorded both with and without a trailing slash, but those point at the same resource and should land in the catalog once, written in the form without the trailing slash. Return the full alphabetical list of endpoints.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Table: rate_limits(limit_id, client, endpoint, allowed, blocked, window, checked)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Sample data - rate_limits ['limit_id', 'client', 'endpoint', 'allowed', 'blocked', 'window', 'checked']:
  [129, 'client-002', '/api/v1/search', 107, None, '5m', '2026-02-02 01:03:00']
  [158, 'client-003', '/api/v1/orders', 114, None, '15m', '2026-03-03 02:06:00']
  [187, 'mobile-app', '/api/v2/analytics', 121, None, '1h', '2026-04-04 03:09:00']
  [216, 'partner-api', '/api/v1/auth', 128, 12, '1d', '2026-05-05 04:12:00']
  [245, 'internal-svc', '/api/v1/payments', 135, None, '1m', '2026-06-06 05:15:00']

Expected output ['endpoint']:
  ['/api/v1/auth']
  ['/api/v1/auth/login']
  ['/api/v1/auth/logout']
  ['/api/v1/orders']
  ['/api/v1/payments']
*/


-- Write your SQL solution below:

SELECT DISTINCT
    CASE
        WHEN length(endpoint) > 1 AND endpoint LIKE '%/'
            THEN rtrim(endpoint, '/')
        ELSE endpoint
    END AS endpoint
FROM (
    SELECT endpoint FROM api_calls
    UNION ALL
    SELECT endpoint FROM rate_limits
)
ORDER BY endpoint ASC
