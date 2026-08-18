-- ======================================================================
-- Cache Efficiency
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cache_efficiency
-- ======================================================================

/*
The infrastructure team wants each edge location compared to the global baseline. For each edge, show its request count, its local cache-hit percentage, and the overall cache-hit percentage across all edges repeated on every row for easy comparison.

Table: cdn_logs(log_id, edge_loc, req_path, status, bytes, cache_hit, served_at)

Sample data - cdn_logs ['log_id', 'edge_loc', 'req_path', 'status', 'bytes', 'cache_hit', 'served_at']:
  [537, 'SFO', '/js/app.min.js', 200, 1437, 0, '2026-02-02 01:07:13']
  [574, 'LHR', '/css/main.css', 200, 2774, 0, '2026-03-03 02:14:26']
  [611, 'NRT', '/images/hero.jpg', 206, 4111, 1, '2026-04-04 03:21:39']
  [648, 'SIN', '/api/v1/data', 301, 5448, 0, '2026-05-05 04:28:52']
  [685, 'FRA', '/fonts/roboto.woff2', 304, None, 0, '2026-06-06 05:35:05']

Expected output ['edge_loc', 'request_count', 'hit_pct', 'overall_hit_pct']:
  ['FRA', 24, 25, 19]
  ['NRT', 26, 23.08, 19]
  ['SIN', 26, 23.08, 19]
  ['GRU', 24, 16.67, 19]
  ['IAD', 24, 16.67, 19]
*/


-- Write your SQL solution below:

SELECT
    edge_loc,
    COUNT(*) AS request_count,
    ROUND(100.0 * SUM(cache_hit) / COUNT(*), 2) AS hit_pct,
    ROUND(
        100.0 * SUM(SUM(cache_hit)) OVER ()
              / SUM(COUNT(*)) OVER (),
        2
    ) AS overall_hit_pct
FROM cdn_logs
GROUP BY edge_loc
ORDER BY hit_pct DESC, edge_loc;
