-- ======================================================================
-- The Quiet Outlier
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/classify_accounts_by_activity_tier
-- ======================================================================

/*
An SRE is chasing a latency outlier but wants to set aside the readings that show up constantly across normal traffic. Among the latency values that appear no more than twice in all API calls, surface the largest one.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['max_unique_latency']:
  [1713.7]
*/


-- Write your SQL solution below:

WITH rare_latencies AS (
  SELECT latency
  FROM api_calls
  GROUP BY latency
  HAVING COUNT(*) <= 2
)
SELECT (
  SELECT MAX(latency)
  FROM rare_latencies
) AS max_unique_latency
