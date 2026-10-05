-- ======================================================================
-- The Days That Line Up
-- ======================================================================
-- Difficulty : Medium
-- Company    : General Assembly
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/pipeline_recovery_by_priority
-- ======================================================================

/*
For each pipeline run that finished successfully after January 1, 2026, match it to every batch job that started on the same calendar day. Report each pipeline name paired with a batch job priority, and for that pairing give the shortest, average, and longest pipeline duration in seconds.

Table: data_pipes(pipe_id, pipe_name, status, rows_in, rows_out, start_at, dur_secs)

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - data_pipes ['pipe_id', 'pipe_name', 'status', 'rows_in', 'rows_out', 'start_at', 'dur_secs']:
  [131, 'etl_users', 'failed', 137, 97, '2026-02-02 01:00:00', 28]
  [162, 'etl_events', 'running', 274, 194, '2026-03-03 02:00:00', 51]
  [193, 'sync_crm', 'queued', 411, 291, '2026-04-04 03:00:00', 74]
  [224, 'agg_daily', 'skipped', 548, 388, '2026-05-05 04:00:00', 97]
  [255, 'agg_weekly', 'Success', 685, 485, '2026-06-06 05:00:00', None]

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['pipe_name', 'priority', 'min_duration', 'avg_duration', 'max_duration']:
  ['agg_daily', 2, 327, 1170.3333333333333, 1937]
  ['agg_daily', 4, 327, 327, 327]
  ['agg_weekly', 5, None, None, None]
  ['agg_weekly', 7, None, None, None]
  ['dbt_build', 5, 2052, 2052, 2052]
*/


-- Write your SQL solution below:

SELECT
    dp.pipe_name,
    bj.priority,
    MIN(dp.dur_secs) AS min_duration,
    AVG(dp.dur_secs) AS avg_duration,
    MAX(dp.dur_secs) AS max_duration
FROM data_pipes dp
INNER JOIN batch_jobs bj
    ON SUBSTR(dp.start_at, 1, 10) = SUBSTR(bj.started, 1, 10)
WHERE dp.start_at > '2026-01-01'
  AND LOWER(dp.status) = 'success'
GROUP BY dp.pipe_name, bj.priority
