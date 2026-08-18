-- ======================================================================
-- Turned Away
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/active_searchers
-- ======================================================================

/*
The API gateway team is reviewing which clients have been rate-limited. List every client that has had at least one request blocked.

Table: rate_limits(limit_id, client, endpoint, allowed, blocked, window, checked)

Sample data - rate_limits ['limit_id', 'client', 'endpoint', 'allowed', 'blocked', 'window', 'checked']:
  [129, 'client-002', '/api/v1/search', 107, None, '5m', '2026-02-02 01:03:00']
  [158, 'client-003', '/api/v1/orders', 114, None, '15m', '2026-03-03 02:06:00']
  [187, 'mobile-app', '/api/v2/analytics', 121, None, '1h', '2026-04-04 03:09:00']
  [216, 'partner-api', '/api/v1/auth', 128, 12, '1d', '2026-05-05 04:12:00']
  [245, 'internal-svc', '/api/v1/payments', 135, None, '1m', '2026-06-06 05:15:00']

Expected output ['client']:
  ['partner-api']
  ['webhook-svc']
  ['client-003']
  ['batch-worker']
  ['client-001']
*/


-- Write your SQL solution below:

SELECT DISTINCT client
FROM rate_limits
WHERE CAST(blocked AS INTEGER) > 0
