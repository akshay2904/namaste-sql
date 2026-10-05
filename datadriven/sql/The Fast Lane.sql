-- ======================================================================
-- The Fast Lane
-- ======================================================================
-- Difficulty : Medium
-- Company    : Travelport
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/efficient_pipeline_throughput
-- ======================================================================

/*
The data platform team is benchmarking the pipelines that finish quickly, those that complete in 45 minutes or less (2700 seconds). For each of those pipelines, find the average rows output, sorted from the highest average to the lowest.

Table: data_pipes(pipe_id, pipe_name, status, rows_in, rows_out, start_at, dur_secs)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Expected output ['pipe_name', 'avg_rows_out']:
  ['ml_train', 5518.222222222223]
  ['import_csv', 5313.444444444444]
  ['agg_daily', 4699.111111111111]
  ['export_s3', 4612.777777777777]
  ['dbt_build', 4401.25]
*/


-- Write your SQL solution below:

SELECT pipe_name, AVG(rows_out) AS avg_rows_out
FROM data_pipes
WHERE dur_secs BETWEEN 0 AND 2700
GROUP BY pipe_name
ORDER BY avg_rows_out DESC
