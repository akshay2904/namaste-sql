-- ======================================================================
-- Job Status Duration
-- ======================================================================
-- Difficulty : Medium
-- Company    : Tesla
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/job_status_duration
-- ======================================================================

/*
Our pipeline tracks batch job state transitions: every time a job changes status, the system records the job ID, timestamp, and status (queued, running, completed). Calculate total hours all jobs spent in each status. Duration is the difference between the current status timestamp and the next status change. For each job's final status, assume it lasted 2 hours. Round to 2 decimal places.

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['status', 'total_hours']:
  ['Completed', 56]
  ['FAILED', 56]
  ['canceled', 56]
  ['failed', 60]
  ['running', 60]
*/


-- Write your SQL solution below:

WITH transitions AS (
    SELECT job_id, status, started,
        LEAD(started) OVER (PARTITION BY job_id ORDER BY started) AS next_started
    FROM batch_jobs
)
SELECT status,
    ROUND(SUM(
        CASE
            WHEN next_started IS NOT NULL
            THEN (JULIANDAY(next_started) - JULIANDAY(started)) * 24
            ELSE 2.0
        END
    ), 2) AS total_hours
FROM transitions
GROUP BY status
