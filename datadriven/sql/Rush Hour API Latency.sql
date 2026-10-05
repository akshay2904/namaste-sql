-- ======================================================================
-- Rush Hour API Latency
-- ======================================================================
-- Difficulty : Medium
-- Company    : Lyft
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/rush_hour_api_latency
-- ======================================================================

/*
For capacity planning in the 'us-east' region, calculate the average latency per hour for API calls made between 15:00 and 17:59 inclusive. Return the hour and average latency.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['hour', 'avg_latency']:
  [15, 326.008]
  [16, 348.5103448275862]
  [17, 339.4916666666667]
*/


-- Write your SQL solution below:

SELECT CAST(strftime('%H', call_time) AS INTEGER) AS hour, AVG(latency) AS avg_latency
FROM api_calls
WHERE CAST(strftime('%H', call_time) AS INTEGER) BETWEEN 15 AND 17
GROUP BY CAST(strftime('%H', call_time) AS INTEGER)
ORDER BY hour
