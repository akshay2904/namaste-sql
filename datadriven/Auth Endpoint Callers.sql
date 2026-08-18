-- ======================================================================
-- Auth Endpoint Callers
-- ======================================================================
-- Difficulty : Medium
-- Company    : Merilytics
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/auth_endpoint_callers
-- ======================================================================

/*
A security review requires tracing which users have hit authentication endpoints. Find every API call whose endpoint path contains 'auth' and show the user's ID, username, email, call ID, and endpoint, ordered by user ID.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['user_id', 'username', 'email', 'call_id', 'endpoint']:
  [100, 'alice', 'alice@example.com', 21394, '/api/v1/auth/login']
  [100, 'alice', 'alice@example.com', 21435, '/api/v1/auth/logout']
  [197, 'aaron42', 'aaron42@example.com', 15268, '/api/v1/auth/login']
  [197, 'aaron42', 'aaron42@example.com', 15347, '/api/v1/auth/login']
  [197, 'aaron42', 'aaron42@example.com', 21436, '/api/v1/auth/logout']
*/


-- Write your SQL solution below:

SELECT
  u.user_id,
  u.username,
  u.email,
  ac.call_id,
  ac.endpoint
FROM users u
INNER JOIN api_calls ac
  ON u.user_id = ac.user_id
WHERE ac.endpoint LIKE '%auth%'
ORDER BY u.user_id
