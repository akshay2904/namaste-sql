-- ======================================================================
-- Minimum Parallel Workers
-- ======================================================================
-- Difficulty : Hard
-- Company    : NVIDIA
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/minimum_parallel_workers
-- ======================================================================

/*
Determine the minimum number of parallel workers required to run all batch jobs without conflicts. Each job has a start and end timestamp and can overlap with others. Duplicate job entries should be counted once, and jobs missing start or end times should be excluded. Find the peak number of concurrently running jobs at any point.

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['min_workers']:
  [1]
*/


-- Write your SQL solution below:

WITH events AS (
    SELECT started AS event_time, 1 AS delta
    FROM (
        SELECT DISTINCT job_id, started, ended
        FROM batch_jobs
        WHERE started IS NOT NULL AND ended IS NOT NULL
    )
    UNION ALL
    SELECT ended AS event_time, -1 AS delta
    FROM (
        SELECT DISTINCT job_id, started, ended
        FROM batch_jobs
        WHERE started IS NOT NULL AND ended IS NOT NULL
    )
),
running AS (
    SELECT event_time,
        SUM(delta) OVER (ORDER BY event_time, delta DESC) AS concurrent
    FROM events
)
SELECT MAX(concurrent) AS min_workers
FROM running
