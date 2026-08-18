-- ======================================================================
-- Batch Job Performance Tiers
-- ======================================================================
-- Difficulty : Medium
-- Company    : Travelport
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/batch_job_performance_tiers
-- ======================================================================

/*
The data platform team is grading batch job throughput for their quarterly review. Each job's total rows processed determines its tier: 30,000 or more is 'Outstanding', 20,000 to 29,999 is 'Satisfactory', 10,000 to 19,999 is 'Unsatisfactory', and anything below 10,000 is 'Poor'. Show each job's name, total rows, and tier, with the highest-throughput jobs first.

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['job_name', 'total_rows', 'performance_tier']:
  ['sync_elastic', 104760, 'Outstanding']
  ['metric_agg', 100880, 'Outstanding']
  ['cache_warm', 97000, 'Outstanding']
  ['email_blast', 93120, 'Outstanding']
  ['user_export', 89240, 'Outstanding']
*/


-- Write your SQL solution below:

SELECT
  job_name,
  SUM(rows_done) AS total_rows,
  CASE
    WHEN SUM(rows_done) >= 30000 THEN 'Outstanding'
    WHEN SUM(rows_done) >= 20000 THEN 'Satisfactory'
    WHEN SUM(rows_done) >= 10000 THEN 'Unsatisfactory'
    ELSE 'Poor'
  END AS performance_tier
FROM batch_jobs
GROUP BY job_name
ORDER BY total_rows DESC;
