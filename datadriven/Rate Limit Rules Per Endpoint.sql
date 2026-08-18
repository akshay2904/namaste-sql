-- ======================================================================
-- Rate Limit Rules Per Endpoint
-- ======================================================================
-- Difficulty : Medium
-- Company    : Vesta Innovations
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/rate_limit_rules_per_endpoint
-- ======================================================================

/*
We need to document rate limit configurations across endpoints. For each endpoint, surface the minimum and maximum allowed values, plus a summary string in the format 'Allowed > X AND Allowed <= Y => Endpoint = /path'. List results by endpoint.

Table: rate_limits(limit_id, client, endpoint, allowed, blocked, window, checked)

Sample data - rate_limits ['limit_id', 'client', 'endpoint', 'allowed', 'blocked', 'window', 'checked']:
  [129, 'client-002', '/api/v1/search', 107, None, '5m', '2026-02-02 01:03:00']
  [158, 'client-003', '/api/v1/orders', 114, None, '15m', '2026-03-03 02:06:00']
  [187, 'mobile-app', '/api/v2/analytics', 121, None, '1h', '2026-04-04 03:09:00']
  [216, 'partner-api', '/api/v1/auth', 128, 12, '1d', '2026-05-05 04:12:00']
  [245, 'internal-svc', '/api/v1/payments', 135, None, '1m', '2026-06-06 05:15:00']

Expected output ['endpoint', 'min_allowed', 'max_allowed', 'summary']:
  ['/api/v1/auth', 128, 800, 'Allowed > 128 AND Allowed <= 800 => Endpoint = /api/v1/auth']
  ['/api/v1/orders', 114, 786, 'Allowed > 114 AND Allowed <= 786 => Endpoint = /api/v1/orders']
  ['/api/v1/payments', 135, 765, 'Allowed > 135 AND Allowed <= 765 => Endpoint = /api/v1/payments']
  ['/api/v1/search', 107, 779, 'Allowed > 107 AND Allowed <= 779 => Endpoint = /api/v1/search']
  ['/api/v1/users', 142, 772, 'Allowed > 142 AND Allowed <= 772 => Endpoint = /api/v1/users']
*/


-- Write your SQL solution below:

SELECT
    endpoint,
    MIN(allowed) AS min_allowed,
    MAX(allowed) AS max_allowed,
    'Allowed > ' || MIN(allowed) || ' AND Allowed <= ' || MAX(allowed) || ' => Endpoint = ' || endpoint AS summary
FROM rate_limits
GROUP BY endpoint
ORDER BY endpoint
