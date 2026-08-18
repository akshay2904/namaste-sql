-- ======================================================================
-- Successful Pipeline Runs
-- ======================================================================
-- Difficulty : Easy
-- Company    : Spotify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/successful_pipeline_runs
-- ======================================================================

/*
The pipeline_runs table tracks every execution of our data pipelines. Pull each pipeline name alongside how many times it completed successfully, sorted from most successful runs to fewest.

Table: data_pipes(pipe_id, pipe_name, status, rows_in, rows_out, start_at, dur_secs)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Expected output ['pipe_name', 'success_count']:
  ['ml_train', 4]
  ['import_csv', 4]
  ['etl_users', 4]
  ['sync_crm', 2]
  ['export_s3', 2]
*/


-- Write your SQL solution below:

SELECT pipe_name, COUNT(*) AS success_count
FROM data_pipes
WHERE status = 'success'
GROUP BY pipe_name
ORDER BY success_count DESC
