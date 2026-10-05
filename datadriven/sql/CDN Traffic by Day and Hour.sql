-- ======================================================================
-- CDN Traffic by Day and Hour
-- ======================================================================
-- Difficulty : Medium
-- Company    : DoorDash
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cdn_traffic_by_day_and_hour
-- ======================================================================

/*
The infra team is sizing CDN edge capacity and wants a throughput heatmap across the week, broken out by weekday and hour of day. For every weekday-and-hour pairing find the average net bytes per request, where net bytes is the gross bytes left after a flat 5 percent transfer overhead is removed; spell the weekday out in full like 'Monday', round the average to two decimals, and lay the rows out in calendar order starting with Sunday, then by hour.

Table: cdn_logs(log_id, edge_loc, req_path, status, bytes, cache_hit, served_at)

Sample data - cdn_logs ['log_id', 'edge_loc', 'req_path', 'status', 'bytes', 'cache_hit', 'served_at']:
  [537, 'SFO', '/js/app.min.js', 200, 1437, 0, '2026-02-02 01:07:13']
  [574, 'LHR', '/css/main.css', 200, 2774, 0, '2026-03-03 02:14:26']
  [611, 'NRT', '/images/hero.jpg', 206, 4111, 1, '2026-04-04 03:21:39']
  [648, 'SIN', '/api/v1/data', 301, 5448, 0, '2026-05-05 04:28:52']
  [685, 'FRA', '/fonts/roboto.woff2', 304, None, 0, '2026-06-06 05:35:05']

Expected output ['weekday', 'hour', 'avg_net_bytes']:
  ['Sunday', 0, 61062.2]
  ['Sunday', 1, 31848.75]
  ['Sunday', 2, 78844.3]
  ['Sunday', 3, None]
  ['Sunday', 4, 127110]
*/


-- Write your SQL solution below:

SELECT
  CASE WHEN strftime('%w', served_at) = '0' THEN 'Sunday'
       WHEN strftime('%w', served_at) = '1' THEN 'Monday'
       WHEN strftime('%w', served_at) = '2' THEN 'Tuesday'
       WHEN strftime('%w', served_at) = '3' THEN 'Wednesday'
       WHEN strftime('%w', served_at) = '4' THEN 'Thursday'
       WHEN strftime('%w', served_at) = '5' THEN 'Friday'
       WHEN strftime('%w', served_at) = '6' THEN 'Saturday'
  END AS weekday,
  CAST(strftime('%H', served_at) AS INTEGER) AS hour,
  ROUND(AVG(bytes * 0.95), 2) AS avg_net_bytes
FROM cdn_logs
GROUP BY strftime('%w', served_at), strftime('%H', served_at)
ORDER BY strftime('%w', served_at), hour
