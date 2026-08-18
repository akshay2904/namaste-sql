-- ======================================================================
-- The Usual Suspects
-- ======================================================================
-- Difficulty : Easy
-- Company    : Vesta Innovations
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/most_common_export_job_status
-- ======================================================================

/*
Export jobs have been flaky lately, so for every batch job whose name contains 'export', count how many landed in each completion status, most common first.

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['status', 'occurrences']:
  ['canceled', 4]
  ['completed', 4]
  ['running', 4]
  ['Completed', 2]
  ['FAILED', 2]
*/


-- Write your SQL solution below:

SELECT status, COUNT(*) AS occurrences
FROM batch_jobs
WHERE job_name LIKE '%export%'
GROUP BY status
ORDER BY occurrences DESC, status
