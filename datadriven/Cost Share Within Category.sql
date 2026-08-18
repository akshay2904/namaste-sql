-- ======================================================================
-- Cost Share Within Category
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cost_share_within_category
-- ======================================================================

/*
The FinOps team is reviewing how spend breaks down inside each category, limited to compute, storage, and network. For every allocation in those categories, return its allocation ID, category, amount, and that amount's share of the category's total, ordered by category then allocation ID.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['alloc_id', 'category', 'amount', 'pct_of_category']:
  [274, 'compute', 449.26, 0.0015938693468477672]
  [448, 'compute', 888.52, 0.0031522610338360372]
  [158, 'network', 156.42, 0.0005442914089297334]
  [332, 'network', 595.68, 0.0020727752619311064]
  [129, 'storage', 83.21, 0.0002923442725695593]
*/


-- Write your SQL solution below:

SELECT
    alloc_id,
    category,
    amount,
    CAST(amount AS REAL) / SUM(amount) OVER (PARTITION BY category) AS pct_of_category
FROM cost_allocs
WHERE category IN ('compute', 'storage', 'network')
ORDER BY category, alloc_id
