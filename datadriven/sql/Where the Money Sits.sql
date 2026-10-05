-- ======================================================================
-- Where the Money Sits
-- ======================================================================
-- Difficulty : Medium
-- Company    : LinkedIn
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/department_cost_by_status
-- ======================================================================

/*
The finance team is building a per-team cost summary. For each team, report how many of its allocations fall in the 'compute' category, alongside the total cost across every allocation the team owns, whatever the category.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['team_name', 'compute_count', 'total_cost']:
  ['DATA-ENG', 0, 179212.3]
  ['Platform', 7, 177568.9]
  ['backend', 6, 161593.91]
  ['data-eng', 0, 175178.1]
  ['legal', 1, 100]
*/


-- Write your SQL solution below:

SELECT
    team_name,
    SUM(CASE WHEN category = 'compute' THEN 1 ELSE 0 END) AS compute_count,
    SUM(amount) AS total_cost
FROM cost_allocs
GROUP BY team_name
