-- ======================================================================
-- Third Largest Batch Job
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/third_largest_batch_job
-- ======================================================================

/*
During the weekly platform review, the data engineering lead asked for the third-largest batch job by total rows processed. If multiple jobs tie for that position, include all of them.

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['job_name', 'total_rows']:
  ['cache_warm', 97000]
*/


-- Write your SQL solution below:

SELECT job_name, total_rows
FROM (
    SELECT
        job_name,
        SUM(rows_done) AS total_rows,
        DENSE_RANK() OVER (ORDER BY SUM(rows_done) DESC) AS rnk
    FROM batch_jobs
    GROUP BY job_name
) ranked
WHERE rnk = 3
ORDER BY job_name;
