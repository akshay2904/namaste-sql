-- ======================================================================
-- Clean Cache CDN Edges
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/clean_cache_cdn_edges
-- ======================================================================

/*
Which CDN edge locations are serving cached content cleanly? Find edges that had a cache hit with a successful HTTP status (below 400). Return only unique edge locations.

Table: cdn_logs(log_id, edge_loc, req_path, status, bytes, cache_hit, served_at)

Sample data - cdn_logs ['log_id', 'edge_loc', 'req_path', 'status', 'bytes', 'cache_hit', 'served_at']:
  [537, 'SFO', '/js/app.min.js', 200, 1437, 0, '2026-02-02 01:07:13']
  [574, 'LHR', '/css/main.css', 200, 2774, 0, '2026-03-03 02:14:26']
  [611, 'NRT', '/images/hero.jpg', 206, 4111, 1, '2026-04-04 03:21:39']
  [648, 'SIN', '/api/v1/data', 301, 5448, 0, '2026-05-05 04:28:52']
  [685, 'FRA', '/fonts/roboto.woff2', 304, None, 0, '2026-06-06 05:35:05']

Expected output ['edge_loc']:
  ['NRT']
  ['SIN']
  ['GRU']
  ['FRA']
  ['IAD']
*/


-- Write your SQL solution below:

SELECT DISTINCT edge_loc
FROM cdn_logs
WHERE cache_hit = 1
  AND status < 400
