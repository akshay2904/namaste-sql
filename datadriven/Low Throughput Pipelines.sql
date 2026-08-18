-- ======================================================================
-- Low Throughput Pipelines
-- ======================================================================
-- Difficulty : Easy
-- Company    : Spotify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/low_throughput_pipelines
-- ======================================================================

/*
The data platform team suspects some pipeline runs are producing suspiciously low output. Surface every individual run with fewer than 2000 rows output, showing the pipeline name and row count from highest to lowest.

Table: data_pipes(pipe_id, pipe_name, status, rows_in, rows_out, start_at, dur_secs)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Expected output ['pipe_name', 'rows_out']:
  ['etl_orders', 1940]
  ['etl_orders', 1940]
  ['dbt_build', 1843]
  ['dbt_build', 1843]
  ['import_csv', 1649]
*/


-- Write your SQL solution below:

SELECT pipe_name, rows_out
FROM data_pipes
WHERE rows_out < 2000
ORDER BY rows_out DESC
