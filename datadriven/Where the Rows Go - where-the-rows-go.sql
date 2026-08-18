-- ======================================================================
-- Where the Rows Go
-- ======================================================================
-- Difficulty : Easy
-- Company    : Verizon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/where-the-rows-go
-- ======================================================================

/*
Our ingestion pipelines read raw records and write cleaned ones, and each job stamps its own run status, so a run that finished shows up as 'success' in whatever mix of upper and lower case that job happens to use. Across the runs that finished successfully, find the pipelines losing the most records between what they read and what they wrote, biggest losses first.

Table: data_pipes(pipe_id, pipe_name, status, rows_in, rows_out, start_at, dur_secs)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Expected output ['pipe_name', 'records_dropped']:
  ['export_s3', 9760]
  ['dbt_build', 8640]
  ['etl_events', 7520]
  ['agg_weekly', 6400]
  ['ml_train', 5440]
*/


-- Write your SQL solution below:

SELECT pipe_name,
       SUM(rows_in - rows_out) AS records_dropped
FROM data_pipes
WHERE LOWER(status) = 'success'
GROUP BY pipe_name
ORDER BY records_dropped DESC
