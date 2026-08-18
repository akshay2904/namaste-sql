-- ======================================================================
-- After Hours API Calls
-- ======================================================================
-- Difficulty : Medium
-- Company    : Vizient
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/after_hours_api_calls
-- ======================================================================

/*
The compliance team is auditing API activity outside business hours for December 2026. Business hours are Monday through Friday, 09:00 to 16:00. All weekend calls and calls on December 25th and 26th count as out-of-hours regardless of time. Return the total count of out-of-hours calls as a decimal value.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['after_hours_count']:
  [6]
*/


-- Write your SQL solution below:

SELECT CAST(COUNT(*) AS REAL) AS after_hours_count
FROM api_calls
WHERE strftime('%Y-%m', call_time) = '2026-12'
  AND (
    CAST(strftime('%w', call_time) AS INTEGER) IN (0, 6)
    OR CAST(strftime('%H', call_time) AS INTEGER) < 9
    OR CAST(strftime('%H', call_time) AS INTEGER) >= 16
    OR strftime('%m-%d', call_time) IN ('12-25', '12-26')
  )
