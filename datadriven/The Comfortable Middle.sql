-- ======================================================================
-- The Comfortable Middle
-- ======================================================================
-- Difficulty : Hard
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/mid_range_team_spenders
-- ======================================================================

/*
A FinOps team is auditing cloud spend and wants the allocations that run hot without being the obvious outliers. Within each team, find the cost allocations above that team's average allocation amount that still fall outside the team's three largest, and return each one's team name and amount.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['team_name', 'amount']:
  ['DATA-ENG', 9857.04]
  ['DATA-ENG', 10768.34]
  ['DATA-ENG', 11679.64]
  ['DATA-ENG', 12590.94]
  ['DATA-ENG', 13502.24]
*/


-- Write your SQL solution below:

WITH team_avg AS (
  SELECT team_name, AVG(amount) AS avg_amount FROM cost_allocs GROUP BY team_name
),
ranked AS (
  SELECT team_name, amount,
         DENSE_RANK() OVER (PARTITION BY team_name ORDER BY amount DESC) AS rnk
  FROM cost_allocs
)
SELECT r.team_name, r.amount
FROM ranked r
INNER JOIN team_avg ta ON r.team_name = ta.team_name
WHERE r.amount > ta.avg_amount AND r.rnk > 3
