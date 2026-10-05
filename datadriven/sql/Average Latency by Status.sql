-- ======================================================================
-- Average Latency by Status
-- ======================================================================
-- Difficulty : Easy
-- Company    : Uber
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_latency_by_status
-- ======================================================================

/*
During a latency spike investigation, the on-call engineer needs to know whether slow responses correlate with specific HTTP status codes. Show the average latency for each status code across all API calls.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['status', 'avg_latency']:
  [200, 226.2494140625]
  [201, 520.78]
  [204, 531.7333333333333]
  [301, 542.6866666666667]
  [400, 553.64]
*/


-- Write your SQL solution below:

SELECT status, AVG(latency) AS avg_latency
FROM api_calls
GROUP BY status
ORDER BY status
