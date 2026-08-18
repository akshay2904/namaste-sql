-- ======================================================================
-- Cheapest Line for Network-Heavy Teams
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/lowest_cost_network_heavy_team
-- ======================================================================

/*
Among teams that spend more on networking than on ML in total, find the single lowest network allocation amount. Team names are compared case-insensitively. Show the team name and that amount.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['team_name', 'amount']:
  ['ml-team', 156.42]
*/


-- Write your SQL solution below:

WITH team_cat AS (SELECT LOWER(team_name) AS team, SUM(CASE WHEN category='network' THEN amount ELSE 0 END) AS net, SUM(CASE WHEN category='ml' THEN amount ELSE 0 END) AS ml FROM cost_allocs GROUP BY LOWER(team_name)), heavy AS (SELECT team FROM team_cat WHERE net > ml) SELECT LOWER(ca.team_name) AS team_name, MIN(ca.amount) AS amount FROM cost_allocs ca JOIN heavy h ON LOWER(ca.team_name)=h.team WHERE ca.category='network' GROUP BY LOWER(ca.team_name) ORDER BY amount ASC LIMIT 1
