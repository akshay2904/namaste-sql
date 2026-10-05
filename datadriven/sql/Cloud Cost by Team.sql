-- ======================================================================
-- Cloud Cost by Team
-- ======================================================================
-- Difficulty : Easy
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cloud_cost_by_team
-- ======================================================================

/*
The VP of Engineering wants to see which teams are driving the most cloud spend for the budget review. Show each team's total cost allocation, from highest to lowest.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['team_name', 'total_cost']:
  ['platform', 180855.7]
  ['DATA-ENG', 179212.3]
  ['Platform', 177568.9]
  ['data-eng', 175178.1]
  ['mobile', 166250.72]
*/


-- Write your SQL solution below:

SELECT team_name, SUM(amount) AS total_cost
FROM cost_allocs
GROUP BY team_name
ORDER BY total_cost DESC
