-- ======================================================================
-- Mid-Range Cost Allocations
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/mid_range_cost_allocations
-- ======================================================================

/*
The FinOps team is auditing mid-tier cost allocations (amounts between 500 and 1,000 inclusive) and needs each entry displayed as a team-service label alongside the amount and region, ordered by amount.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['label', 'amount', 'region']:
  ['mobile - SQS', 522.47, 'eu-central-1']
  ['Platform - EC2', 595.68, 'us-east-1']
  ['DATA-ENG - S3', 668.89, 'us-west-2']
  ['platform - RDS', 742.1, 'eu-west-1']
  ['data-eng - Lambda', 815.31, 'ap-south-1']
*/


-- Write your SQL solution below:

SELECT team_name || ' - ' || svc_name AS label, amount, region FROM cost_allocs WHERE amount BETWEEN 500 AND 1000 ORDER BY amount
