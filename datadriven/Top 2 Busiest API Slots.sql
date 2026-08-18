-- ======================================================================
-- Top 2 Busiest API Slots
-- ======================================================================
-- Difficulty : Medium
-- Company    : Travelport
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_2_busiest_api_slots
-- ======================================================================

/*
Segment each day's API traffic into 'Morning' (before 12:00), 'Early Afternoon' (12:00 to 15:00), and 'Late Afternoon' (after 15:00). Find the top 2 day-plus-time-segment combinations by total API calls; if there's a tie, include all tied results. Exclude records with missing timestamps.

Table: api_calls(call_id, endpoint, method, status, latency, user_id, call_time, err_msg)

Sample data - api_calls ['call_id', 'endpoint', 'method', 'status', 'latency', 'user_id', 'call_time', 'err_msg']:
  [8079, '/api/v1/orders', 'POST', 200, 4.2, 100, '2026-02-02 01:07:00', None]
  [8158, '/api/v2/products', 'PUT', 200, 7.9, 197, '2026-03-03 02:14:00', None]
  [8237, '/api/v1/search', 'DELETE', 201, 11.6, 294, '2026-04-04 03:21:00', None]
  [8316, '/api/v1/auth/login', 'PATCH', 204, 15.3, 391, '2026-05-05 04:28:00', None]
  [8395, '/api/v1/auth/logout', 'get', 301, 19, None, '2026-06-06 05:35:00', None]

Expected output ['day_of_week', 'time_segment', 'call_count']:
  [1, 'Morning', 63]
  [4, 'Morning', 52]
  [6, 'Morning', 52]
*/


-- Write your SQL solution below:

WITH segmented AS (
  SELECT
    CAST(strftime('%w', call_time) AS INTEGER) AS day_of_week,
    CASE
      WHEN CAST(strftime('%H', call_time) AS INTEGER) < 12 THEN 'Morning'
      WHEN CAST(strftime('%H', call_time) AS INTEGER) <= 15 THEN 'Early Afternoon'
      ELSE 'Late Afternoon'
    END AS time_segment,
    COUNT(*) AS call_count
  FROM api_calls
  WHERE call_time IS NOT NULL
  GROUP BY day_of_week, time_segment
),
ranked AS (
  SELECT *, DENSE_RANK() OVER (ORDER BY call_count DESC) AS rnk
  FROM segmented
)
SELECT day_of_week, time_segment, call_count
FROM ranked
WHERE rnk <= 2
