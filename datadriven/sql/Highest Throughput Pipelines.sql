-- ======================================================================
-- Highest Throughput Pipelines
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/highest_throughput_pipelines
-- ======================================================================

/*
The data platform team is sizing infrastructure for next year based on 2025 peak loads. For each pipeline, show its maximum rows output from any single run that year, sorted from highest throughput to lowest.

Table: data_pipes(pipe_id, pipe_name, status, rows_in, rows_out, start_at, dur_secs)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Expected output ['pipe_name', 'max_throughput']:
  ['etl_orders', 9700]
  ['ml_train', 9506]
  ['import_csv', 9409]
  ['export_s3', 9312]
  ['agg_weekly', 9215]
*/


-- Write your SQL solution below:

SELECT pipe_name, MAX(rows_out) AS max_throughput FROM data_pipes WHERE strftime('%Y', start_at) = '2026' GROUP BY pipe_name ORDER BY max_throughput DESC
