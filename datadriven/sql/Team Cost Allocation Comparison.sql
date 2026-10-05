-- ======================================================================
-- Team Cost Allocation Comparison
-- ======================================================================
-- Difficulty : Hard
-- Company    : Walmart
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/team_cost_allocation_comparison
-- ======================================================================

/*
The FinOps team wants each team member's cost allocation compared against their team lead's allocation and the team average. For each entry, show the member's amount, the highest amount in their team (as the lead's benchmark), and the team average, with the biggest spenders in each team first.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['team_name', 'svc_name', 'amount', 'manager_amount', 'dept_avg']:
  ['DATA-ENG', 'EC2', 18058.74, 18058.74, 8960.615]
  ['DATA-ENG', 'EKS', 17147.44, 18058.74, 8960.615]
  ['DATA-ENG', 'BigQuery', 16236.14, 18058.74, 8960.615]
  ['DATA-ENG', 'RDS', 15324.84, 18058.74, 8960.615]
  ['DATA-ENG', 'EC2', 14413.54, 18058.74, 8960.615]
*/


-- Write your SQL solution below:

WITH managers AS (
    SELECT team_name, MAX(amount) AS mgr_amount
    FROM cost_allocs
    GROUP BY team_name
)
SELECT ca.team_name, ca.svc_name, ca.amount, m.mgr_amount AS manager_amount, AVG(ca.amount) OVER (PARTITION BY ca.team_name) AS dept_avg
FROM cost_allocs ca
LEFT
JOIN managers m ON ca.team_name = m.team_name
WHERE ca.amount IS NOT NULL
ORDER BY ca.team_name, ca.amount DESC
