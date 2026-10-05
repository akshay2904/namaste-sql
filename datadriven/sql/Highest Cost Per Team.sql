-- ======================================================================
-- Highest Cost Per Team
-- ======================================================================
-- Difficulty : Easy
-- Company    : Forbes
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/highest_cost_per_team
-- ======================================================================

/*
The FinOps team flags any team whose peak single cost allocation looks unusually high. Show the highest allocation amount for each team (team names are compared case-insensitively) so they can identify outliers.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['team_name', 'max_amount']:
  ['data-eng', 18241]
  ['platform', 18149.87]
  ['mobile', 17876.48]
  ['security', 17785.35]
  ['devops', 17694.22]
*/


-- Write your SQL solution below:

SELECT LOWER(team_name) AS team_name, MAX(amount) AS max_amount FROM cost_allocs GROUP BY LOWER(team_name) ORDER BY max_amount DESC
