-- ======================================================================
-- Top Cost Categories
-- ======================================================================
-- Difficulty : Medium
-- Company    : Uber
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_cost_categories
-- ======================================================================

/*
Categories are tracked in the budget allocation system (cost_allocs), but actual billing amounts live in the cost tracking system (cloud_costs). Attribute each cloud charge to its budget category by matching the allocation for the same service, region, and billing month (cloud_costs.bill_date's year-month equals cost_allocs.period). A (service, region) pair alone maps to several categories across months, so the month is required to make the attribution unambiguous; a service can also appear under several teams in the same period, so collapse (service, region, month) to one category before summing or each charge is counted multiple times. Show the top 3 categories by total attributed amount.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['category', 'total_amount']:
  ['ml', 3714.64]
  ['network', 2037.1200000000001]
  ['storage', 1108.46]
*/


-- Write your SQL solution below:

WITH cat_map AS (
  SELECT DISTINCT svc_name, region, period, category
  FROM cost_allocs
)
SELECT m.category,
       SUM(cc.amount) AS total_amount
FROM cloud_costs cc
JOIN cat_map m
  ON cc.svc_name = m.svc_name
 AND cc.region   = m.region
 AND strftime('%Y-%m', cc.bill_date) = m.period
GROUP BY m.category
ORDER BY total_amount DESC
LIMIT 3;
