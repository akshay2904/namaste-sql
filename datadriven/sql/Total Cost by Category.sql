-- ======================================================================
-- Total Cost by Category
-- ======================================================================
-- Difficulty : Easy
-- Company    : Siemens
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/total_cost_by_category
-- ======================================================================

/*
The FinOps team needs category-level totals for the annual budget review. For each cost allocation category, return the sum of all amounts.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['category', 'total_amount']:
  ['compute', 281867.52]
  ['database', 290135.47]
  ['ml', 274555.99]
  ['network', 287382.82]
  ['other', 269813.3]
*/


-- Write your SQL solution below:

SELECT category, SUM(amount) AS total_amount
FROM cost_allocs
GROUP BY category
