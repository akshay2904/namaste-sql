-- ======================================================================
-- Largest CDN Response
-- ======================================================================
-- Difficulty : Hard
-- Company    : ESPN
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/largest_cdn_response
-- ======================================================================

/*
The CDN team wants to know which edge location served the largest single response in 2026. For that response, show the edge location, the size in numeric bytes (the bytes column may have a trailing 'KB' suffix that needs to be stripped), and the request path.

Table: cdn_logs(log_id, edge_loc, req_path, status, bytes, cache_hit, served_at)

Sample data - cdn_logs ['log_id', 'edge_loc', 'req_path', 'status', 'bytes', 'cache_hit', 'served_at']:
  [537, 'SFO', '/js/app.min.js', 200, 1437, 0, '2026-02-02 01:07:13']
  [574, 'LHR', '/css/main.css', 200, 2774, 0, '2026-03-03 02:14:26']
  [611, 'NRT', '/images/hero.jpg', 206, 4111, 1, '2026-04-04 03:21:39']
  [648, 'SIN', '/api/v1/data', 301, 5448, 0, '2026-05-05 04:28:52']
  [685, 'FRA', '/fonts/roboto.woff2', 304, None, 0, '2026-06-06 05:35:05']

Expected output ['log_id', 'edge_loc', 'req_path', 'status', 'bytes', 'cache_hit', 'served_at']:
  [4200, 'SIN', '/assets/logo.png', 200, 133800, 0, '2026-05-17 04:40:40']
*/


-- Write your SQL solution below:

SELECT log_id, edge_loc, req_path, status, bytes, cache_hit, served_at
FROM cdn_logs
ORDER BY bytes DESC
LIMIT 1
