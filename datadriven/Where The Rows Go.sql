-- ======================================================================
-- Where The Rows Go
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/pipeline_throughput_ratio
-- ======================================================================

/*
The data platform team measures how efficiently each pipeline run turns the rows it reads into the rows it writes back out. For every run, show the pipeline name, its start time, and the ratio of rows written to rows read to four decimal places, ordered by pipeline name and then start time.

Table: data_pipes(pipe_id, pipe_name, rows_in, rows_out, start_at)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Expected output ['pipe_name', 'start_at', 'throughput_ratio']:
  ['agg_daily', '2025-02-15 14:00:00', None]
  ['agg_weekly', '2026-01-02 13:00:00', 0.708]
  ['dbt_build', '2025-01-22 01:00:00', None]
  ['etl_events', '2023-02-03 02:00:00', 0.708]
  ['etl_orders', '2026-01-05 12:00:00', 0.708]
*/


-- Write your SQL solution below:

SELECT
    pipe_name,
    start_at,
    ROUND(rows_out * 1.0 / NULLIF(rows_in, 0), 4) AS throughput_ratio
FROM data_pipes
ORDER BY pipe_name, start_at
