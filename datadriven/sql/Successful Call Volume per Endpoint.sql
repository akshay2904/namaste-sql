-- ======================================================================
-- Successful Call Volume per Endpoint
-- ======================================================================
-- Difficulty : Medium
-- Company    : PayPal
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/successful_call_volume_per_endpoint
-- ======================================================================

/*
The API gateway logs duplicate events from retry middleware. In the api_calls table, duplicate rows share the same user_id, endpoint, and call_time. Keep only the row with the lowest call_id from each duplicate group. After deduplication, find the total number of successful calls per endpoint. A successful call has status equal to 200. Return each endpoint and its successful call count, ordered from most to fewest.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'successful_calls']:
  ['/api/v1/users', 116]
  ['/api/v1/orders', 113]
  ['/api/v2/products', 107]
  ['/api/v1/search', 66]
  ['/api/v1/auth/login', 51]
*/


-- Write your SQL solution below:

WITH deduped AS (
    SELECT DISTINCT ON (user_id, endpoint, call_time) *
    FROM api_calls
    ORDER BY user_id, endpoint, call_time, call_id
)
SELECT
    endpoint,
    COUNT(*) AS successful_calls
FROM deduped
WHERE status = 200
GROUP BY endpoint
ORDER BY successful_calls DESC;
