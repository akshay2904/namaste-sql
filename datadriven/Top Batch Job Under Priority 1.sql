-- ======================================================================
-- Top Batch Job Under Priority 1
-- ======================================================================
-- Difficulty : Medium
-- Company    : Salesforce
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_batch_job_under_priority_1
-- ======================================================================

/*
The data platform team is benchmarking throughput for the highest-priority batch jobs. Among priority-1 jobs, which one processed the most rows? If multiple jobs tie for the top value, include all of them.

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['job_id', 'job_name', 'rows_done']:
  [5559, 'metric_agg', 9409]
  [10005797, 'metric_agg', 9409]
*/


-- Write your SQL solution below:

SELECT job_id, job_name, rows_done
FROM batch_jobs
WHERE priority = 1
  AND rows_done = (SELECT MAX(rows_done) FROM batch_jobs WHERE priority = 1)
ORDER BY job_id
