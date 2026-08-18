-- ======================================================================
-- Cloud Cost Breakdown by Provider
-- ======================================================================
-- Difficulty : Hard
-- Company    : ESPN
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cloud_cost_breakdown_by_provider
-- ======================================================================

/*
The FinOps team wants a multi-year cost breakdown from 2022 through 2025. For each cost category and year in the allocation records, show the total spend, the spend specifically in the us-east-1 region, and the number of line items, from the highest total spend down.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['category', 'yr', 'total_spend', 'us_east_spend', 'entry_count']:
  ['other', '2025', 57289.64, 0, 4]
  ['ml', '2025', 56925.12, 0, 4]
  ['database', '2023', 56560.6, 0, 4]
  ['network', '2023', 56196.08, 24270.58, 4]
  ['other', '2024', 52915.4, 0, 4]
*/


-- Write your SQL solution below:

SELECT
    category,
    substr(period, 1, 4) AS yr,
    SUM(amount) AS total_spend,
    SUM(CASE WHEN region = 'us-east-1' THEN amount ELSE 0 END) AS us_east_spend,
    COUNT(*) AS entry_count
FROM cost_allocs
WHERE substr(period, 1, 4) >= '2022'
  AND substr(period, 1, 4) <= '2025'
GROUP BY category, yr
ORDER BY total_spend DESC, category, yr
