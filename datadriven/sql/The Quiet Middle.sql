-- ======================================================================
-- The Quiet Middle
-- ======================================================================
-- Difficulty : Easy
-- Company    : Spotify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/mid_tier_batch_jobs
-- ======================================================================

/*
We're auditing the batch pipeline and want the jobs in the overlooked middle by rows processed: not the busiest, not the idlest. Line them up from most rows to least, then return positions 8 through 10, each job's name with its position, lowest position first.

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['job_name', 'rnk']:
  ['data_cleanup', 8]
  ['data_cleanup', 8]
  ['user_export', 9]
  ['user_export', 9]
  ['sync_elastic', 10]
*/


-- Write your SQL solution below:

SELECT job_name, rnk
FROM (
    SELECT job_name, DENSE_RANK() OVER (ORDER BY rows_done DESC) AS rnk
    FROM batch_jobs
) ranked
WHERE rnk BETWEEN 8 AND 10
ORDER BY rnk, job_name
