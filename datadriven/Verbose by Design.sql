-- ======================================================================
-- Verbose by Design
-- ======================================================================
-- Difficulty : Hard
-- Company    : City and County of San Francisco
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/endpoint_name_word_count
-- ======================================================================

/*
A platform team is auditing endpoint paths in the request log, where the outer slashes are noise but every inner segment marks a real routing level. For each distinct path, report its length once the outer slashes are ignored and how many meaningful segments it holds, deepest paths first.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['endpoint', 'trimmed_len', 'word_count']:
  ['/api/v1/auth/login', 17, 4]
  ['/api/v1/auth/logout', 18, 4]
  ['/api/v1/orders', 13, 3]
  ['/api/v1/payments', 15, 3]
  ['/api/v1/search', 13, 3]
*/


-- Write your SQL solution below:

WITH RECURSIVE
endpoints AS (
  SELECT DISTINCT endpoint FROM api_calls
),

split(endpoint, seg, rest) AS (
  SELECT endpoint, '', endpoint || '/' FROM endpoints
  UNION ALL
  SELECT endpoint,
         substr(rest, 1, instr(rest, '/') - 1),
         substr(rest, instr(rest, '/') + 1)
  FROM split
  WHERE rest <> ''
),
segments AS (

  SELECT endpoint, seg
  FROM split
  WHERE seg <> ''
)
SELECT s.endpoint,
       LENGTH(TRIM(s.endpoint, '/')) AS trimmed_len,
       COUNT(*)                      AS word_count
FROM segments s
GROUP BY s.endpoint
ORDER BY word_count DESC, s.endpoint;
