-- ======================================================================
-- Pipeline Completion Rate
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/pipeline_completion_rate
-- ======================================================================

/*
For each pipeline, calculate the average completion percentage, where completion is the ratio of rows out to rows in. Exclude runs where rows in is zero. Show the pipeline name and its average completion percentage.

Table: data_pipes(pipe_id, pipe_name, status, rows_in, rows_out, start_at, dur_secs)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Expected output ['pipe_name', 'avg_completion_pct']:
  ['agg_daily', 70.8029197080292]
  ['dbt_build', 60.6867056565565]
  ['etl_events', 61.951562995874326]
  ['export_s3', 61.9505712472231]
  ['sync_crm', 62.93240241193272]
*/


-- Write your SQL solution below:

SELECT
    pipe_name,
    AVG(rows_out * 100.0 / rows_in) AS avg_completion_pct
FROM data_pipes
WHERE rows_in > 0
GROUP BY pipe_name
