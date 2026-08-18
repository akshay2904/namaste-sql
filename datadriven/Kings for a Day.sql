-- ======================================================================
-- Kings for a Day
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/fastest_completion_per_day
-- ======================================================================

/*
We run a batch-processing platform where jobs record how many rows they moved and the time they started. For each calendar day, find the job that moved the most rows, and when two jobs tie for a day's highest count, report all of them. Return the day, the job name, and its row count, earliest day first.

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['job_date', 'job_name', 'rows_done']:
  ['2022-01-02', 'user_export', 97]
  ['2022-01-06', 'user_export', 5917]
  ['2022-02-03', 'log_archive', 8342]
  ['2022-02-27', 'log_archive', 2522]
  ['2022-03-24', 'user_export', 4947]
*/


-- Write your SQL solution below:

WITH ranked AS (
  SELECT
    DATE(started) AS job_date,
    job_name,
    rows_done,
    RANK() OVER (
      PARTITION BY DATE(started)
      ORDER BY rows_done DESC
    ) AS rnk
  FROM batch_jobs
  WHERE rows_done IS NOT NULL
)
SELECT job_date, job_name, rows_done
FROM ranked
WHERE rnk = 1
ORDER BY job_date
