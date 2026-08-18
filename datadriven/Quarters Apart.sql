-- ======================================================================
-- Quarters Apart
-- ======================================================================
-- Difficulty : Hard
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/quarter_over_quarter_latency_trend
-- ======================================================================

/*
The reliability team reports API latency to leadership one quarter at a time and wants to see how each quarter compares to the one before it. For the three calendar years before 2026, show every quarter in order with its average latency, the previous quarter's average, and the difference between them; if a quarter has no calls, treat its average as 120.0.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['quarter', 'avg_latency', 'prev_avg_latency', 'qoq_change']:
  ['2023-Q1', 199.95000000000002, None, None]
  ['2023-Q2', 186.35714285714286, 199.95000000000002, -13.592857142857156]
  ['2023-Q3', 199.95000000000002, 186.35714285714286, 13.592857142857156]
  ['2023-Q4', 251.85, 199.95000000000002, 51.89999999999998]
  ['2024-Q1', 675.7, 251.85, 423.85]
*/


-- Write your SQL solution below:

$1a
