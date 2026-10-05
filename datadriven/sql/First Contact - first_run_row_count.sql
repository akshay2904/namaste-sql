-- ======================================================================
-- First Contact
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/first_run_row_count
-- ======================================================================

/*
The data platform team wants to see how many rows each batch job processed on its very first run, as a baseline for measuring throughput improvements over time. Show the job name and rows done from that first execution.

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['job_name', 'rows_done']:
  ['backup_db', 3686]
  ['cache_warm', 8245]
  ['daily_report', None]
  ['data_cleanup', 194]
  ['email_blast', 1261]
*/


-- Write your SQL solution below:

SELECT job_name, rows_done
FROM (
    SELECT job_name, rows_done,
           ROW_NUMBER() OVER (PARTITION BY job_name ORDER BY started ASC) AS rn
    FROM batch_jobs
) ranked
WHERE rn = 1
ORDER BY job_name
