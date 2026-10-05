-- ======================================================================
-- Total Rows by Pipeline Status
-- ======================================================================
-- Difficulty : Easy
-- Company    : Zenefits
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/total_rows_by_pipeline_status
-- ======================================================================

/*
The data platform team wants each pipeline run row enriched with a status-level benchmark: the total rows ingested across all pipelines sharing the same status. Preserve every original column and add the status-wide total as an additional column.

Table: data_pipes(pipe_id, pipe_name, status, rows_in, rows_out, start_at, dur_secs)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Expected output ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs', 'status_total_rows_in']:
  [286, 'export_s3', 'FAILED', 822, 582, '2026-07-07 06:00:00', 143, 197554]
  [503, 'sync_crm', 'FAILED', 1781, 1261, '2026-02-14 13:00:00', 304, 197554]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None, 193718]
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28, 205500]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74, 186046]
*/


-- Write your SQL solution below:

SELECT
    pipe_id,
    pipe_name,
    status,
    rows_in,
    rows_out,
    start_at,
    dur_secs,
    SUM(rows_in) OVER (PARTITION BY status) AS status_total_rows_in
FROM data_pipes
