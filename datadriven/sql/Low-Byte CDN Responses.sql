-- ======================================================================
-- Low-Byte CDN Responses
-- ======================================================================
-- Difficulty : Easy
-- Company    : Salesforce
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/low_byte_cdn_responses
-- ======================================================================

/*
The CDN team suspects some responses are suspiciously small, possibly indicating truncated or error payloads. Pull all log entries where bytes served is under 5000, showing every available field, ordered from smallest response up.

Table: cdn_logs(log_id, edge_loc, req_path, status, bytes, cache_hit, served_at)

Sample data - cdn_logs ['log_id', 'edge_loc', 'req_path', 'status', 'bytes', 'cache_hit', 'served_at']:
  [537, 'SFO', '/js/app.min.js', 200, 1437, 0, '2026-02-02 01:07:13']
  [574, 'LHR', '/css/main.css', 200, 2774, 0, '2026-03-03 02:14:26']
  [611, 'NRT', '/images/hero.jpg', 206, 4111, 1, '2026-04-04 03:21:39']
  [648, 'SIN', '/api/v1/data', 301, 5448, 0, '2026-05-05 04:28:52']
  [685, 'FRA', '/fonts/roboto.woff2', 304, None, 0, '2026-06-06 05:35:05']

Expected output ['log_id', 'edge_loc', 'req_path', 'status', 'bytes', 'cache_hit', 'served_at']:
  [537, 'SFO', '/js/app.min.js', 200, 1437, 0, '2026-02-02 01:07:13']
  [10004201, 'SFO', '/js/app.min.js', 200, 1437, 0, '2022-01-02 01:07:13']
  [574, 'LHR', '/css/main.css', 200, 2774, 0, '2026-03-03 02:14:26']
  [10004202, 'LHR', '/css/main.css', 200, 2774, 0, '2023-02-03 02:14:26']
  [611, 'NRT', '/images/hero.jpg', 206, 4111, 1, '2026-04-04 03:21:39']
*/


-- Write your SQL solution below:

SELECT log_id, edge_loc, req_path, status, bytes, cache_hit, served_at
FROM cdn_logs
WHERE bytes < 5000
ORDER BY bytes ASC
