-- ======================================================================
-- The Budget Line
-- ======================================================================
-- Difficulty : Easy
-- Company    : W. W. Grainger
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/budget_flag
-- ======================================================================

/*
The FinOps team needs to flag every service-region combination as 'over', 'under', or 'on_target' by comparing the actual cloud cost against the budgeted allocation for that same service and region. Show the service, region, actual cost, budget, and the flag.

Table: cloud_costs(cost_id, svc_name, region, amount)

Table: cost_allocs(alloc_id, svc_name, region, amount)

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

Expected output ['svc_name', 'region', 'actual_cost', 'budget', 'budget_flag']:
  ['S3', 'us-west-2', 19.33, 83.21, 'under']
  ['S3', 'us-west-2', 19.33, 150, 'under']
  ['RDS', 'eu-west-1', 37.16, 156.42, 'under']
  ['BigQuery', 'us-central1', 72.82, 302.84, 'under']
  ['EC2', 'us-central1', 179.8, 300, 'under']
*/


-- Write your SQL solution below:

SELECT
  cc.svc_name,
  cc.region,
  cc.amount AS actual_cost,
  ca.amount AS budget,
  CASE
    WHEN cc.amount > ca.amount THEN 'over'
    WHEN cc.amount < ca.amount THEN 'under'
    ELSE 'on_target'
  END AS budget_flag
FROM cloud_costs cc
JOIN cost_allocs ca
  ON cc.svc_name = ca.svc_name
 AND cc.region = ca.region
