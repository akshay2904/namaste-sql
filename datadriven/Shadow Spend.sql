-- ======================================================================
-- Shadow Spend
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/combined_cloud_spend_by_region_and_service
-- ======================================================================

/*
The FinOps team wants a single view of cloud spend that merges the billed cost records with the internal allocation records, counting a line item that appears in both only once. Drop any row with no amount or no region, then report the total spend for each region and service pairing, highest first.

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

Expected output ['region', 'svc_name', 'total_spend']:
  ['ap-south-1', 'RDS', 170775.36]
  ['eu-west-1', 'S3', 169681.8]
  ['us-west-2', 'EC2', 168588.24]
  ['us-east-1', 'SQS', 167494.68]
  ['eu-central-1', 'EKS', 166401.12]
*/


-- Write your SQL solution below:

WITH combined AS (
    SELECT region, svc_name, amount FROM cloud_costs
    WHERE amount IS NOT NULL AND region IS NOT NULL
    UNION
    SELECT region, svc_name, amount FROM cost_allocs
    WHERE amount IS NOT NULL AND region IS NOT NULL
)
SELECT region, svc_name, SUM(amount) AS total_spend
FROM combined
GROUP BY region, svc_name
ORDER BY total_spend DESC
