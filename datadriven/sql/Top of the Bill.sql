-- ======================================================================
-- Top of the Bill
-- ======================================================================
-- Difficulty : Medium
-- Company    : Slickdeals
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_2_cloud_services_by_cost
-- ======================================================================

/*
Finance is reviewing the cloud bills and wants to see which services dominate the spend. Among the services that also appear in the cost allocations, find the two with the highest total cloud cost.

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

Expected output ['svc_name', 'total_amount']:
  ['BigQuery', 17503.4]
  ['CloudFront', 17296.920000000002]
*/


-- Write your SQL solution below:

SELECT cc.svc_name,
       SUM(cc.amount) AS total_amount
FROM cloud_costs cc
WHERE cc.svc_name IN (SELECT svc_name FROM cost_allocs)
GROUP BY cc.svc_name
ORDER BY total_amount DESC
LIMIT 2;
