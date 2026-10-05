-- ======================================================================
-- Top API Caller
-- ======================================================================
-- Difficulty : Medium
-- Company    : Walmart
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_api_caller
-- ======================================================================

/*
Find the user who triggered the most API calls, showing their user ID and total call count.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['user_id', 'call_count']:
  [None, 17]
*/


-- Write your SQL solution below:

SELECT
  user_id,
  COUNT(*) AS call_count
FROM api_calls
GROUP BY user_id
ORDER BY call_count DESC
LIMIT 1;
