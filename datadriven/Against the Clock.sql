-- ======================================================================
-- Against the Clock
-- ======================================================================
-- Difficulty : Easy
-- Company    : Instacart
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/slow_batch_jobs
-- ======================================================================

/*
Our batch scheduler stores each job's start and end time as Unix epoch seconds, writing the end time only once a job finishes, so jobs still running or killed mid-flight have no end time. For the jobs that finished, report how many whole minutes each one ran, alongside its job_id and job_name.

Table: batch_jobs(job_id, job_name, started, ended)

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['job_id', 'job_name', 'minutes_elapsed']:
  [1047, 'user_export', 0]
  [1094, 'data_cleanup', 0]
  [1141, 'email_blast', 0]
  [1235, 'cache_warm', 0]
  [1282, 'log_archive', 0]
*/


-- Write your SQL solution below:

SELECT job_id, job_name, (ended - started) / 60 AS minutes_elapsed
FROM batch_jobs
WHERE ended IS NOT NULL AND ended > started
