-- ======================================================================
-- Below the Peaks
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/median_household_earnings
-- ======================================================================

/*
Finance is auditing outlier allocations within each team. Surface the allocations that land above their team's own average yet outside that team's five biggest by amount, and return the team name and the amount.

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
  SELECT team_name, AVG(amount) AS avg_amount
  FROM cost_allocs
  GROUP BY team_name
),
ranked AS (
  SELECT ca.team_name, ca.amount,
         ROW_NUMBER() OVER (PARTITION BY ca.team_name ORDER BY ca.amount DESC) AS rn
  FROM cost_allocs ca
)
SELECT r.team_name, r.amount
FROM ranked r
INNER JOIN team_avg ta ON r.team_name = ta.team_name
WHERE r.amount > ta.avg_amount AND r.rn > 5
