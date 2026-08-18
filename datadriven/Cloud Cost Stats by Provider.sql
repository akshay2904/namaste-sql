-- ======================================================================
-- Cloud Cost Stats by Provider
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cloud_cost_stats_by_provider
-- ======================================================================

/*
The FinOps team needs a unified view of costs across both actual cloud spending and internal allocations. Treating both sources as a single dataset, show each provider with its minimum, maximum, and average cost amount.

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

Expected output ['provider', 'min_amount', 'max_amount', 'avg_amount']:
  ['AWS', -268.5, 1784.5, 797.3000000000001]
  ['Azure', -181.1, 1731.01, 824.1395]
  ['GCP', -224.8, 1713.18, 787.186]
  ['aws', -137.4, 1748.84, 861.0930000000001]
  ['compute', 100, 17967.61, 8541.44]
*/


-- Write your SQL solution below:

WITH combined AS (
    SELECT provider, amount FROM cloud_costs
    UNION ALL
    SELECT category AS provider, amount FROM cost_allocs
)
SELECT
    provider,
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    AVG(amount) AS avg_amount
FROM combined
GROUP BY provider
