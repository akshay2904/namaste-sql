-- ======================================================================
-- Bargains and Budget-Busters
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/bargains_and_budget_busters
-- ======================================================================

/*
FinOps is auditing cloud spend region by region. Two systems record line items: the provider's cost ledger and the team's internal allocations. Treat them as one combined stream of line items. For each region, name the service behind the single biggest line item and the service behind the single smallest. If two line items tie, take the one whose service name comes first alphabetically. Return one row per region with the region, its biggest spender, and its cheapest line item.

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

Expected output ['region', 'most_expensive', 'cheapest']:
  ['ap-south-1', 'RDS', 'Lambda']
  ['ap-southeast-1', 'CloudFront', 'Cloud Run']
  ['eu-central-1', 'EKS', 'SQS']
  ['eu-west-1', 'S3', 'CloudFront']
  ['europe-west1', 'BigQuery', 'Cloud Run']
*/


-- Write your SQL solution below:

WITH combined AS (
    SELECT region, svc_name, amount FROM cloud_costs
    UNION ALL
    SELECT region, svc_name, amount FROM cost_allocs
),
ranked AS (
    SELECT
        region,
        svc_name,
        amount,
        FIRST_VALUE(svc_name) OVER (PARTITION BY region ORDER BY amount DESC, svc_name ASC) AS most_expensive,
        FIRST_VALUE(svc_name) OVER (PARTITION BY region ORDER BY amount ASC,  svc_name ASC) AS cheapest
    FROM combined
)
SELECT DISTINCT region, most_expensive, cheapest
FROM ranked
