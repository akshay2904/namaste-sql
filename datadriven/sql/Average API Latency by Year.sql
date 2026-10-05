-- ======================================================================
-- Average API Latency by Year
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_api_latency_by_year
-- ======================================================================

/*
During the weekly platform review, the VP of Engineering asked whether API latency has been trending up. Show the average latency for each endpoint in each year, ordered by year and then by endpoint.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['call_year', 'endpoint', 'avg_latency']:
  ['2023', '/api/v1/auth/login', 225.9]
  ['2023', '/api/v1/auth/logout', 243.2]
  ['2024', '/api/v1/auth/login', 641.1]
  ['2025', '/api/v1/auth/login', 1056.3]
  ['2026', '/api/v1/auth/login', 245.47903225806454]
*/


-- Write your SQL solution below:

SELECT strftime('%Y', call_time) AS call_year, endpoint, AVG(latency) AS avg_latency FROM api_calls GROUP BY call_year, endpoint ORDER BY call_year, endpoint
