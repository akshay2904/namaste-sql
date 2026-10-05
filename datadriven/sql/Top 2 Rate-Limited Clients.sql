-- ======================================================================
-- Top 2 Rate-Limited Clients
-- ======================================================================
-- Difficulty : Medium
-- Company    : TripAdvisor
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_2_rate_limited_clients
-- ======================================================================

/*
The API gateway team is cracking down on abusive traffic patterns. Find the two clients generating the most blocked requests, where a request counts as blocked when the blocked value is greater than 0. Show each client and their blocked count, sorted from most blocked to least.

Table: rate_limits(limit_id, client, endpoint, allowed, blocked, window, checked)

Sample data - rate_limits ['limit_id', 'client', 'endpoint', 'allowed', 'blocked', 'window', 'checked']:
  [129, 'client-002', '/api/v1/search', 107, None, '5m', '2026-02-02 01:03:00']
  [158, 'client-003', '/api/v1/orders', 114, None, '15m', '2026-03-03 02:06:00']
  [187, 'mobile-app', '/api/v2/analytics', 121, None, '1h', '2026-04-04 03:09:00']
  [216, 'partner-api', '/api/v1/auth', 128, 12, '1d', '2026-05-05 04:12:00']
  [245, 'internal-svc', '/api/v1/payments', 135, None, '1m', '2026-06-06 05:15:00']

Expected output ['client', 'total_blocked']:
  ['client-001', 1800]
  ['batch-worker', 1680]
*/


-- Write your SQL solution below:

SELECT client, SUM(blocked) AS total_blocked
FROM rate_limits
WHERE blocked > 0
GROUP BY client
ORDER BY total_blocked DESC, client ASC
LIMIT 2
