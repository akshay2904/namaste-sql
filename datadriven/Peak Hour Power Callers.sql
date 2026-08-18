-- ======================================================================
-- Peak Hour Power Callers
-- ======================================================================
-- Difficulty : Medium
-- Company    : Redfin
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/peak_hour_power_callers
-- ======================================================================

/*
Support is tracking who leans hardest on the API during the afternoon window, from 3 to 6 PM. Find the users who placed at least 3 calls in that window along with their call counts, busiest first.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['user_id', 'call_count']:
  [391, 4]
  [None, 3]
  [1555, 3]
  [3786, 3]
*/


-- Write your SQL solution below:

SELECT user_id, COUNT(*) AS call_count
FROM api_calls
WHERE CAST(strftime('%H', call_time) AS INTEGER) BETWEEN 15 AND 17
GROUP BY user_id
HAVING COUNT(*) >= 3
ORDER BY call_count DESC, user_id
