-- ======================================================================
-- Peak Concurrent Batch Jobs
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/peak_concurrent_batch_jobs
-- ======================================================================

/*
We're sizing scheduler capacity around the worst pile-up. A job occupies a slot from its start time up to its end time, so if one job ends at the exact instant another starts, the two never overlap. Return the largest number of jobs running at the same instant, as a single number.

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['peak']:
  [1]
*/


-- Write your SQL solution below:

WITH events AS (
    SELECT started AS ts, 1 AS delta FROM batch_jobs WHERE started IS NOT NULL AND ended IS NOT NULL
    UNION ALL
    SELECT ended AS ts, -1 AS delta FROM batch_jobs WHERE started IS NOT NULL AND ended IS NOT NULL
)
SELECT MAX(running) AS peak FROM (
    SELECT SUM(delta) OVER (ORDER BY ts, delta ROWS UNBOUNDED PRECEDING) AS running
    FROM events
)
