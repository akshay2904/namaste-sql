-- ======================================================================
-- Node Utilization
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/node_utilization
-- ======================================================================

/*
The capacity planning team is hunting for overloaded nodes against their regional baseline. In infra_nodes, compute the average cpu_pct per region (skipping NULL cpu_pct), then find nodes whose cpu_pct exceeds their own region's average. Within each region rank those nodes sorted from highest cpu_pct to lowest with ties sharing a position. Return the hostname, region, cpu_pct, regional average, and position.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['team_name', 'region', 'total_amount', 'rnk']:
  ['data-eng', 'ap-south-1', 55018.53, 1]
  ['frontend', 'ap-south-1', 51074.37, 2]
  ['DATA-ENG', 'ap-south-1', 39992.65, 3]
  ['devops', 'ap-south-1', 37993.74, 4]
  ['mobile', 'ap-south-1', 35364.3, 5]
*/


-- Write your SQL solution below:

WITH team_totals AS (
  SELECT team_name, region, SUM(CAST(amount AS DOUBLE)) AS total_amount
  FROM cost_allocs
  GROUP BY team_name, region
  HAVING SUM(CAST(amount AS DOUBLE)) > 0
)
SELECT team_name, region, total_amount, RANK() OVER (PARTITION BY region ORDER BY total_amount DESC) AS rnk
FROM team_totals
ORDER BY region, rnk, team_name
