-- ======================================================================
-- Echo Chamber
-- ======================================================================
-- Difficulty : Medium
-- Company    : Amazon
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/api_calls_with_matching_status
-- ======================================================================

/*
A reliability review is hunting for duplicated API responses: cases where two different calls returned the same HTTP method and the same status code. List those matching pairs by their two call IDs, highest status codes first, and keep only the top 20.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['call_id_1', 'call_id_2', 'method', 'status']:
  [8948, 16492, 'get', 503]
  [9975, 17025, 'PATCH', 503]
  [8869, 16451, 'PATCH', 502]
  [9896, 16984, 'DELETE', 502]
  [8790, 16410, 'DELETE', 500]
*/


-- Write your SQL solution below:

SELECT a.call_id AS call_id_1, b.call_id AS call_id_2, a.method, a.status
FROM api_calls a
JOIN api_calls b
  ON a.method = b.method
 AND a.status = b.status
 AND a.call_id < b.call_id
ORDER BY a.status DESC, a.call_id, b.call_id
LIMIT 20
