-- ======================================================================
-- Total Engineering Cost Allocation
-- ======================================================================
-- Difficulty : Easy
-- Company    : Forbes
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/total_engineering_cost_allocation
-- ======================================================================

/*
The CFO is reviewing the cloud allocation total for engineering. Engineering teams in the allocation table are 'data-eng', 'backend', 'devops', and 'platform' (case-insensitive). What is the sum of allocated amounts across those teams?

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['total_amount']:
  [1037555.09]
*/


-- Write your SQL solution below:

SELECT SUM(amount) AS total_amount
FROM cost_allocs
WHERE LOWER(team_name) IN ('data-eng', 'backend', 'devops', 'platform');
