-- ======================================================================
-- Cheapest CDN Route
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cheapest_cdn_route
-- ======================================================================

/*
The CDN team wants the cheapest delivery from the SFO edge. Among successful (status 200) responses served from SFO, what is the smallest byte payload? Return a single value.

Table: cdn_logs(log_id, edge_loc, req_path, status, bytes, cache_hit, served_at)

Sample data - cdn_logs ['log_id', 'edge_loc', 'req_path', 'status', 'bytes', 'cache_hit', 'served_at']:
  [537, 'SFO', '/js/app.min.js', 200, 1437, 0, '2026-02-02 01:07:13']
  [574, 'LHR', '/css/main.css', 200, 2774, 0, '2026-03-03 02:14:26']
  [611, 'NRT', '/images/hero.jpg', 206, 4111, 1, '2026-04-04 03:21:39']
  [648, 'SIN', '/api/v1/data', 301, 5448, 0, '2026-05-05 04:28:52']
  [685, 'FRA', '/fonts/roboto.woff2', 304, None, 0, '2026-06-06 05:35:05']

Expected output ['cheapest_cost']:
  [1437]
*/


-- Write your SQL solution below:

SELECT MIN(bytes) AS cheapest_cost
FROM cdn_logs
WHERE LOWER(edge_loc) = 'sfo'
  AND status = 200
