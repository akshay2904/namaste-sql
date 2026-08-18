-- ======================================================================
-- One-Track Mind
-- ======================================================================
-- Difficulty : Medium
-- Company    : Linux
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/endpoint_with_most_get_only_users
-- ======================================================================

/*
We're profiling read-only API users: people who have only ever called the API with GET and never any other method. For each endpoint, count these read-only users, and return the endpoint or endpoints with the highest count.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'get_only_users']:
  ['/api/v1/orders', 24]
  ['/api/v1/users', 24]
  ['/api/v2/products', 24]
*/


-- Write your SQL solution below:

WITH counts AS (SELECT endpoint, COUNT(DISTINCT user_id) AS get_only_users FROM api_calls WHERE UPPER(method)='GET' AND user_id IS NOT NULL AND user_id NOT IN (SELECT DISTINCT user_id FROM api_calls WHERE UPPER(method)!='GET' AND user_id IS NOT NULL) GROUP BY endpoint) SELECT endpoint, get_only_users FROM counts WHERE get_only_users = (SELECT MAX(get_only_users) FROM counts) ORDER BY endpoint
