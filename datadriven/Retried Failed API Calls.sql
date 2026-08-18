-- ======================================================================
-- Retried Failed API Calls
-- ======================================================================
-- Difficulty : Medium
-- Company    : PayPal
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/retried_failed_api_calls
-- ======================================================================

/*
Reliability wants to spot clients retrying after errors. A retry is a call that comes within 5 minutes after the same user's previous call to the same endpoint when that previous call returned a non-200 status. Return user_id, endpoint, and the retry count, sorted by retry count descending, then user_id, then endpoint.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['user_id', 'endpoint', 'retry_count']:
  [197, '/api/v1/auth/login', 3]
  [100, '/api/v1/payments', 2]
  [294, '/api/v1/orders', 1]
  [391, '/api/v2/analytics', 1]
*/


-- Write your SQL solution below:

WITH prev_calls AS (
    SELECT
        user_id,
        endpoint,
        call_time,
        status,
        LAG(status) OVER (PARTITION BY user_id, endpoint ORDER BY call_time) AS prev_status,
        LAG(call_time) OVER (PARTITION BY user_id, endpoint ORDER BY call_time) AS prev_call_time
    FROM api_calls
    WHERE user_id IS NOT NULL
)
SELECT
    user_id,
    endpoint,
    COUNT(*) AS retry_count
FROM prev_calls
WHERE prev_status IS NOT NULL
  AND prev_status <> 200
  AND call_time <= prev_call_time + INTERVAL '5 minutes'
GROUP BY user_id, endpoint
ORDER BY retry_count DESC, user_id, endpoint;
