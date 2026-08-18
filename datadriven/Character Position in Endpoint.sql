-- ======================================================================
-- Character Position in Endpoint
-- ======================================================================
-- Difficulty : Easy
-- Company    : Square
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/character_position_in_endpoint
-- ======================================================================

/*
While debugging a routing issue, an engineer needs to locate where the letter 'a' first appears in each API endpoint string (case-insensitive). Show the endpoint and the character position, excluding endpoints that don't contain 'a' at all, ordered by call ID.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'a_position']:
  ['/api/v1/orders', 2]
  ['/api/v2/products', 2]
  ['/api/v1/search', 2]
  ['/api/v1/auth/login', 2]
  ['/api/v1/auth/logout', 2]
*/


-- Write your SQL solution below:

SELECT endpoint, INSTR(LOWER(endpoint), 'a') AS a_position
FROM api_calls
WHERE INSTR(LOWER(endpoint), 'a') > 0
ORDER BY call_id
