-- ======================================================================
-- Top 2 Callers per Endpoint
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_2_callers_per_endpoint
-- ======================================================================

/*
For each endpoint, show the top 2 users by API call volume. If users are tied, include all of them at the same rank. Return the endpoint, user ID, and their rank.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['endpoint', 'user_id', 'rnk']:
  ['/api/v1/auth/login', 197, 1]
  ['/api/v1/auth/logout', None, 1]
  ['/api/v1/orders', 294, 1]
  ['/api/v1/payments', 100, 1]
  ['/api/v1/search', 9315, 1]
*/


-- Write your SQL solution below:

SELECT endpoint, user_id, rnk
FROM (
  SELECT
    endpoint,
    user_id,
    COUNT(*) AS call_count,
    DENSE_RANK() OVER (
      PARTITION BY endpoint
      ORDER BY COUNT(*) DESC
    ) AS rnk
  FROM api_calls
  GROUP BY endpoint, user_id
) ranked
WHERE rnk <= 2
ORDER BY endpoint, rnk;
