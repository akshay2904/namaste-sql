-- ======================================================================
-- Rapid Retry Detection
-- ======================================================================
-- Difficulty : Medium
-- Company    : Vanguard
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/rapid_retry_detection
-- ======================================================================

/*
During an incident postmortem, the on-call engineer needs to detect retry storms. Using the api_calls table, find all calls where the same user hit the same endpoint within 5 minutes after a call that returned an error status (status >= 400). Return the user_id, endpoint, the failed call time, and the retry call time.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['user_id', 'endpoint', 'failed_call_time', 'retry_call_time']:
  [100, '/api/v1/payments', '2026-06-15 14:00:00', '2026-06-15 14:02:00']
  [100, '/api/v1/payments', '2026-06-15 14:00:00', '2026-06-15 14:04:00']
  [197, '/api/v1/auth/login', '2026-06-15 09:00:00', '2026-06-15 09:02:00']
  [294, '/api/v1/orders', '2026-06-15 11:30:00', '2026-06-15 11:33:00']
  [391, '/api/v2/analytics', '2026-06-15 16:00:00', '2026-06-15 16:01:00']
*/


-- Write your SQL solution below:

SELECT a.user_id, a.endpoint, a.call_time AS failed_call_time, b.call_time AS retry_call_time
FROM api_calls a
JOIN api_calls b
  ON a.user_id = b.user_id
 AND a.endpoint = b.endpoint
 AND b.call_time > a.call_time
 AND (julianday(b.call_time) - julianday(a.call_time)) * 24 * 60 <= 5
WHERE a.status >= 400 AND a.user_id IS NOT NULL
