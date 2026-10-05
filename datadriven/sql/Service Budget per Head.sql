-- ======================================================================
-- Service Budget per Head
-- ======================================================================
-- Difficulty : Medium
-- Company    : Microsoft
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/service_budget_per_head
-- ======================================================================

/*
For each service that appears in both the cost tracking and budget allocation systems, count how many unique teams are allocated to it and divide total allocated amount by that count, rounded to the nearest integer. Show highest budget per head first.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

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

Expected output ['svc_name', 'budget_per_head']:
  ['RDS', 436984]
  ['CloudFront', 416950]
  ['BigQuery', 408318]
  ['Lambda', 404410]
  ['S3', 334149]
*/


-- Write your SQL solution below:

SELECT cc.svc_name, ROUND(SUM(ca.amount) / COUNT(DISTINCT ca.team_name)) AS budget_per_head
FROM cloud_costs cc
INNER JOIN cost_allocs ca ON cc.svc_name = ca.svc_name
GROUP BY cc.svc_name
ORDER BY budget_per_head DESC
