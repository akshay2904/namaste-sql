-- ======================================================================
-- Low Latency API Calls
-- ======================================================================
-- Difficulty : Easy
-- Company    : British Airways
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/low_latency_api_calls
-- ======================================================================

/*
The performance team is building a baseline dataset of fast API calls, defined as anything at or below 100 milliseconds. Pull all matching call records.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [16000, '/api/v1/users', 'GET', 200, 1, 4950, '2023-01-01 00:00:00', None]
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [21000, '/api/v1/users', 'GET', 200, 10, 2137, '2026-02-01 00:00:00', None]
  [21110, '/api/v1/orders', 'GET', 200, 10, 5144, '2026-02-01 00:00:00', None]
*/


-- Write your SQL solution below:

SELECT * FROM api_calls WHERE latency <= 100 ORDER BY latency ASC, call_id ASC
