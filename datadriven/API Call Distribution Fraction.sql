-- ======================================================================
-- API Call Distribution Fraction
-- ======================================================================
-- Difficulty : Hard
-- Company    : Lyft
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/api_call_distribution_fraction
-- ======================================================================

/*
The API observability team is building a traffic breakdown dashboard. For each combination of HTTP method and response status in the call logs, compute what share of total call volume that combination represents. Return the method, status, and the fraction as a decimal.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['method', 'status', 'fraction']:
  ['GET', 200, 0.7223880597014926]
  ['POST', 200, 0.022388059701492536]
  ['PUT', 200, 0.010447761194029851]
  ['DELETE', 200, 0.008955223880597015]
  ['PATCH', 200, 0.008955223880597015]
*/


-- Write your SQL solution below:

WITH normalized AS (
    SELECT UPPER(method) AS method, status
    FROM api_calls
)
SELECT
    method,
    status,
    CAST(COUNT(*) AS REAL) / SUM(COUNT(*)) OVER () AS fraction
FROM normalized
GROUP BY method, status
ORDER BY fraction DESC, method ASC, status ASC
