-- ======================================================================
-- The Ones Nobody Calls
-- ======================================================================
-- Difficulty : Medium
-- Company    : Microsoft
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/bottom_endpoints_by_post_volume
-- ======================================================================

/*
The API deprecation team is hunting for endpoints that barely see any POST traffic, the natural candidates for sunsetting. The method field is logged inconsistently, sometimes lowercase, so treat every casing of POST as the same request. Show the two lowest positions by POST call volume, quietest first, with each endpoint, its call count, and its position.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'call_count', 'rnk']:
  ['/api/v2/products/', 2, 1]
  ['/api/v1/users/', 3, 2]
  ['/api/v2/analytics', 3, 2]
*/


-- Write your SQL solution below:

SELECT endpoint, call_count, rnk
FROM (
    SELECT
        endpoint,
        COUNT(*) AS call_count,
        DENSE_RANK() OVER (ORDER BY COUNT(*) ASC) AS rnk
    FROM api_calls
    WHERE UPPER(method) = 'POST'
    GROUP BY endpoint
) ranked
WHERE rnk <= 2
ORDER BY call_count ASC, endpoint ASC
