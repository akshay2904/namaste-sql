-- ======================================================================
-- Annual Pipeline Failures
-- ======================================================================
-- Difficulty : Easy
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/annual_pipeline_failures
-- ======================================================================

/*
The data engineering team is reviewing historical reliability for the 'etl_users' pipeline. Count the number of failed runs per year, excluding any runs without a recorded start time. Present results from the earliest year to the latest.

Table: data_pipes(pipe_id, pipe_name, status, rows_in, rows_out, start_at, dur_secs)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Expected output ['run_year', 'failed_runs']:
  ['2022', 3]
  ['2026', 3]
*/


-- Write your SQL solution below:

SELECT
    strftime('%Y', start_at) AS run_year,
    COUNT(*) AS failed_runs
FROM data_pipes
WHERE LOWER(status) = 'failed'
  AND pipe_name = 'etl_users'
  AND start_at IS NOT NULL
GROUP BY run_year
ORDER BY run_year ASC
