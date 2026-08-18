-- ======================================================================
-- Pipeline Run History
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/pipeline_run_history
-- ======================================================================

/*
For each pipeline in data_pipes, show the first run date, the most recent run date, and the total number of separate runs, with the most recently started pipelines first.

Table: data_pipes(pipe_id, pipe_name, status, rows_in, rows_out, start_at, dur_secs)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Expected output ['pipe_name', 'first_run', 'last_run', 'run_count']:
  ['sync_crm', '2024-01-14 13:00:00', '2026-12-28 11:00:00', 20]
  ['import_csv', '2023-01-10 13:00:00', '2026-12-20 23:00:00', 20]
  ['etl_users', '2022-01-02 01:00:00', '2026-12-16 23:00:00', 20]
  ['agg_weekly', '2026-01-02 13:00:00', '2026-12-12 23:00:00', 20]
  ['etl_orders', '2026-01-05 12:00:00', '2026-12-05 12:00:00', 20]
*/


-- Write your SQL solution below:

SELECT
    pipe_name,
    MIN(start_at) AS first_run,
    MAX(start_at) AS last_run,
    COUNT(DISTINCT start_at) AS run_count
FROM data_pipes
GROUP BY pipe_name
ORDER BY MAX(start_at) DESC
