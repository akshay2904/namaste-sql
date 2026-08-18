-- ======================================================================
-- Monthly Active Users per Endpoint
-- ======================================================================
-- Difficulty : Easy
-- Company    : Twitter, Inc.
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_active_users_per_endpoint
-- ======================================================================

/*
The API product team needs to size per-endpoint user reach during June 2026 to inform deprecation decisions. For each endpoint, how many unique users called it that month?

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'user_count']:
  ['/api/v1/auth/login', 1]
  ['/api/v1/auth/logout', 0]
  ['/api/v1/orders', 2]
  ['/api/v1/payments', 3]
  ['/api/v2/analytics', 1]
*/


-- Write your SQL solution below:

SELECT endpoint, COUNT(DISTINCT user_id) AS user_count FROM api_calls WHERE strftime('%Y-%m', call_time) = '2026-06' GROUP BY endpoint
