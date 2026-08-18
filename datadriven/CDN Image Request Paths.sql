-- ======================================================================
-- CDN Image Request Paths
-- ======================================================================
-- Difficulty : Easy
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cdn_image_request_paths
-- ======================================================================

/*
The CDN team is investigating image serving patterns. Pull the edge location and request path for every log entry where the path includes 'image'.

Table: cdn_logs(log_id, edge_loc, req_path, status, bytes, cache_hit, served_at)

Sample data - cdn_logs ['log_id', 'edge_loc', 'req_path', 'status', 'bytes', 'cache_hit', 'served_at']:
  [537, 'SFO', '/js/app.min.js', 200, 1437, 0, '2026-02-02 01:07:13']
  [574, 'LHR', '/css/main.css', 200, 2774, 0, '2026-03-03 02:14:26']
  [611, 'NRT', '/images/hero.jpg', 206, 4111, 1, '2026-04-04 03:21:39']
  [648, 'SIN', '/api/v1/data', 301, 5448, 0, '2026-05-05 04:28:52']
  [685, 'FRA', '/fonts/roboto.woff2', 304, None, 0, '2026-06-06 05:35:05']

Expected output ['edge_loc', 'req_path']:
  ['NRT', '/images/hero.jpg']
  ['FRA', '/images/hero.jpg']
  ['GRU', '/images/hero.jpg']
  ['SFO', '/images/hero.jpg']
  ['NRT', '/images/hero.jpg']
*/


-- Write your SQL solution below:

SELECT edge_loc, req_path
FROM cdn_logs
WHERE req_path LIKE '%image%'
