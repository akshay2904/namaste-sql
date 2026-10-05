-- ======================================================================
-- Zero-Retry Job Ratio by Priority
-- ======================================================================
-- Difficulty : Hard
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/zero_retry_job_ratio_by_priority
-- ======================================================================

/*
The batch processing system tracks retry counts per job. Calculate the ratio of jobs that completed without any retries to total jobs, broken down by priority level. A zero-retry job has retries equal to 0. Show the priority, count of zero-retry jobs, total jobs for that priority, and the ratio, from lowest ratio to highest.

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['priority', 'zero_retry_count', 'total_jobs', 'ratio']:
  [7, 16, 20, 0.8]
  [0, 18, 20, 0.9]
  [1, 18, 20, 0.9]
  [2, 18, 20, 0.9]
  [3, 18, 20, 0.9]
*/


-- Write your SQL solution below:

SELECT
    priority,
    SUM(CASE WHEN retries = 0 THEN 1 ELSE 0 END) AS zero_retry_count,
    COUNT(*) AS total_jobs,
    SUM(CASE WHEN retries = 0 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS ratio
FROM batch_jobs
GROUP BY priority
ORDER BY ratio ASC
