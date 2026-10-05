-- ======================================================================
-- Top 100 Batch Jobs Total Output
-- ======================================================================
-- Difficulty : Easy
-- Company    : Spotify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_100_batch_jobs_total_output
-- ======================================================================

/*
Sum the rows processed by the top 100 batch jobs ranked by rows completed. If jobs are tied, they share the same rank. Return that single total.

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['total_rows']:
  [821396]
*/


-- Write your SQL solution below:

SELECT SUM(rows_done) AS total_rows
FROM (
  SELECT rows_done,
         DENSE_RANK() OVER (ORDER BY rows_done DESC) AS rnk
  FROM batch_jobs
)
WHERE rnk <= 100
