-- ======================================================================
-- Latency Variance and Std Dev
-- ======================================================================
-- Difficulty : Hard
-- Company    : Vesta Innovations
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/latency_variance_and_std_dev
-- ======================================================================

/*
For successful API calls (status 200), compute the mean latency, variance, and standard deviation.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['mean_latency', 'variance_latency', 'stddev_latency']:
  [226.2494140625, 45607.50585903168, 213.5591390201592]
*/


-- Write your SQL solution below:

SELECT
  (SELECT AVG(latency)
     FROM api_calls
     WHERE status = 200) AS mean_latency,
  (SELECT AVG(latency * latency) - AVG(latency) * AVG(latency)
     FROM api_calls
     WHERE status = 200) AS variance_latency,
  SQRT(
    (SELECT AVG(latency * latency) - AVG(latency) * AVG(latency)
       FROM api_calls
       WHERE status = 200)
  ) AS stddev_latency;
