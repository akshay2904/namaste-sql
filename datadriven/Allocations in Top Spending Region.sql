-- ======================================================================
-- Allocations in Top Spending Region
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/allocations_in_top_spending_region
-- ======================================================================

/*
The FinOps team is investigating cost allocation for the region with the highest total cloud spend. Identify which region tops the cloud cost table by total amount, then pull all cost allocation records for teams operating in that region. Return all available fields.

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

Expected output ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [361, 'DATA-ENG', 'S3', 'us-west-2', 668.89, '2026-10', 'acct-109', 'database']
  [593, 'mobile', 'S3', 'us-west-2', 1254.57, '2026-06', 'acct-102', 'other']
  [3290, 'data-eng', 'EC2', 'us-west-2', 10039.3, '2023-10', None, 'database']
  [3522, 'DATA-ENG', 'EC2', 'us-west-2', 10768.34, '2024-06', 'acct-218', 'other']
*/


-- Write your SQL solution below:

WITH top_region AS (
  SELECT region
  FROM cloud_costs
  GROUP BY region
  ORDER BY SUM(amount) DESC, region ASC
  LIMIT 1
)
SELECT ca.*
FROM cost_allocs ca
WHERE ca.region = (SELECT region FROM top_region)
ORDER BY ca.alloc_id;
