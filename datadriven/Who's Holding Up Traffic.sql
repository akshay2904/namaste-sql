-- ======================================================================
-- Who's Holding Up Traffic
-- ======================================================================
-- Difficulty : Medium
-- Company    : Workday
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/avg_daily_active_users_per_endpoint
-- ======================================================================

/*
The API product team wants to understand typical daily traffic per endpoint during June 2026. For each endpoint, what was the average number of unique users hitting it on a given day that month?

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'avg_daily_active_users']:
  ['/api/v1/auth/login', 1]
  ['/api/v1/auth/logout', 0]
  ['/api/v1/orders', 1]
  ['/api/v1/payments', 1]
  ['/api/v1/search', 2]
*/


-- Write your SQL solution below:

SELECT endpoint,
       AVG(daily_users) AS avg_daily_active_users
FROM (
  SELECT endpoint,
         DATE(call_time) AS call_day,
         COUNT(DISTINCT user_id) AS daily_users
  FROM api_calls
  WHERE strftime('%Y-%m', call_time) = '2026-06'
  GROUP BY endpoint, DATE(call_time)
) sub
GROUP BY endpoint
ORDER BY endpoint;
