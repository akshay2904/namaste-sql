-- ======================================================================
-- The Shape of a Day
-- ======================================================================
-- Difficulty : Medium
-- Company    : Uber
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/peak_api_hour
-- ======================================================================

/*
Capacity planning wants the shape of an average day: for each hour of the clock, how many API calls land in a typical day. Return every hour with that average daily call count, busiest first.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['call_hour', 'avg_count']:
  [1, 3.2]
  [13, 3]
  [0, 2.3846153846153846]
  [4, 2.3076923076923075]
  [5, 2.3076923076923075]
*/


-- Write your SQL solution below:

WITH hourly AS (
    SELECT
        DATE(call_time) AS call_date,
        CAST(strftime('%H', call_time) AS INTEGER) AS call_hour,
        COUNT(*) AS call_count
    FROM api_calls
    GROUP BY call_date, call_hour
)
SELECT call_hour, AVG(call_count) AS avg_count
FROM hourly
GROUP BY call_hour
ORDER BY avg_count DESC, call_hour
