-- ======================================================================
-- Where the Money Went
-- ======================================================================
-- Difficulty : Medium
-- Company    : LinkedIn
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/over_budget_services
-- ======================================================================

/*
We reconcile each team's budget allocation against the actual cloud charge for the same service in the same billing month, prorating every pairing to an hourly figure by multiplying the allocated amount by the actual cost and dividing by the hours in a year. Return each service with its total prorated cost, highest first, keeping only services whose total comes out positive.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Table: batch_jobs(job_id, job_name, status, rows_done, started, ended, priority, retries)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Sample data - batch_jobs ['job_id', 'job_name', 'status', 'rows_done', 'started', 'ended', 'priority', 'retries']:
  [1047, 'user_export', 'running', 97, '2026-02-02 01:00:00', '2026-02-02 03:11:00', 3, 0]
  [1094, 'data_cleanup', 'failed', 194, '2026-03-03 02:00:00', '2026-03-03 04:22:00', 6, 0]
  [1141, 'email_blast', 'queued', 291, '2026-04-04 03:00:00', '2026-04-04 05:33:00', 9, 0]
  [1188, 'index_rebuild', 'canceled', 388, '2026-05-05 04:00:00', None, 2, 0]
  [1235, 'cache_warm', 'Completed', 485, '2026-06-06 05:00:00', '2026-06-06 07:55:00', 5, 0]

Expected output ['svc_name', 'prorated_cost']:
  ['Lambda', 18098.682740753426]
  ['RDS', 14274.871266575343]
  ['BigQuery', 10319.61518063927]
  ['CloudFront', 9158.666312968038]
  ['EC2', 7096.954842009132]
*/


-- Write your SQL solution below:

SELECT
    ca.svc_name AS svc_name,
    SUM(ca.amount * cc.amount / 8760.0) AS prorated_cost
FROM cost_allocs ca
INNER JOIN cloud_costs cc
    ON ca.svc_name = cc.svc_name
    AND ca.period = strftime('%Y-%m', cc.bill_date)
GROUP BY ca.svc_name
HAVING SUM(ca.amount * cc.amount / 8760.0) > 0
ORDER BY prorated_cost DESC, svc_name ASC;
