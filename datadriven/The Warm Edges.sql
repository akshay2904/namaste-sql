-- ======================================================================
-- The Warm Edges
-- ======================================================================
-- Difficulty : Medium
-- Company    : Postmates
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/api_traffic_by_cdn_edge
-- ======================================================================

/*
The CDN team is comparing API traffic at the edge locations that are actually caching: those that have logged at least one cache hit on any path. For request paths that include 'api', find the average bytes served at each of those edge locations and path combination, from the lowest average to the highest.

Table: cdn_logs(log_id, edge_loc, req_path, status, bytes, cache_hit, served_at)

Sample data - cdn_logs ['log_id', 'edge_loc', 'req_path', 'status', 'bytes', 'cache_hit', 'served_at']:
  [537, 'SFO', '/js/app.min.js', 200, 1437, 0, '2026-02-02 01:07:13']
  [574, 'LHR', '/css/main.css', 200, 2774, 0, '2026-03-03 02:14:26']
  [611, 'NRT', '/images/hero.jpg', 206, 4111, 1, '2026-04-04 03:21:39']
  [648, 'SIN', '/api/v1/data', 301, 5448, 0, '2026-05-05 04:28:52']
  [685, 'FRA', '/fonts/roboto.woff2', 304, None, 0, '2026-06-06 05:35:05']

Expected output ['edge_loc', 'req_path', 'avg_bytes']:
  ['IAD', '/api/v1/data', 58928]
  ['SIN', '/api/v1/data', 58928]
  ['LHR', '/api/v1/data', 72298]
  ['SYD', '/api/v1/data', 72298]
*/


-- Write your SQL solution below:

SELECT
  cl.edge_loc,
  cl.req_path,
  AVG(cl.bytes) AS avg_bytes
FROM cdn_logs cl
JOIN (
  SELECT DISTINCT edge_loc
  FROM cdn_logs
  WHERE cache_hit = 1
) cached
  ON cl.edge_loc = cached.edge_loc
WHERE cl.req_path LIKE '%api%'
GROUP BY cl.edge_loc, cl.req_path
ORDER BY avg_bytes;
