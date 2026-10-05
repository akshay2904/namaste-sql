-- ======================================================================
-- Last Five Batch Jobs
-- ======================================================================
-- Difficulty : Easy
-- Company    : Visa
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/last_five_batch_jobs
-- ======================================================================

/*
Quick tail check on recent pipeline runs. Pull the five most recent batch job records by job ID, from newest to oldest. For each job, show the job ID, name, status, rows completed, start time, end time, priority, and retries.

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [10005800, 'daily_report', 'failed', 9700, '2026-04-17 04:00:00', None, 0, 0]
  [10005799, 'sync_elastic', 'running', 9603, '2025-03-16 03:00:00', '2025-03-16 05:09:00', 7, 5]
  [10005798, 'backup_db', 'completed', 9506, '2024-02-15 02:00:00', '2024-02-15 04:58:00', 4, 0]
  [10005797, 'metric_agg', 'FAILED', 9409, '2023-01-14 01:00:00', '2023-01-14 03:47:00', 1, 0]
  [10005796, 'log_archive', 'Completed', None, '2022-12-13 00:00:00', None, 8, 0]
*/


-- Write your SQL solution below:

SELECT job_id, job_name, status, rows_done, started, ended, priority, retries
FROM batch_jobs
ORDER BY job_id DESC
LIMIT 5
