-- ======================================================================
-- Busiest Pipeline Month
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/busiest_pipeline_month
-- ======================================================================

/*
The data platform team is planning maintenance windows and wants to avoid the busiest month. Which month of the year had the highest number of pipeline executions? Show the month number and the count.

Table: data_pipes(pipe_id, pipe_name, status, rows_in, rows_out, start_at, dur_secs)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Expected output ['month', 'pipeline_runs']:
  ['04', 18]
*/


-- Write your SQL solution below:

SELECT
    STRFTIME('%m', start_at) AS month,
    COUNT(*) AS pipeline_runs
FROM data_pipes
WHERE start_at IS NOT NULL
GROUP BY STRFTIME('%m', start_at)
ORDER BY pipeline_runs DESC
LIMIT 1
