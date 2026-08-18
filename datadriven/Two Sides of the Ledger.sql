-- ======================================================================
-- Two Sides of the Ledger
-- ======================================================================
-- Difficulty : Hard
-- Company    : Uber
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_regional_cost_reconciliation
-- ======================================================================

/*
The FinOps team reconciles each region's cloud charges against its budget allocations on a single monthly timeline, where a charge draws the region's balance down and an allocation builds it back up. Charges are stamped with a full billing date while allocations are recorded by month, so line each charge up on its month before combining the two sources. For every region and month, show the net movement and the balance standing after it, earliest month first within each region.

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

Expected output ['region', 'event_date', 'amt', 'running_balance']:
  ['ap-south-1', '2023-04', 32107.760000000002, 32107.760000000002]
  ['ap-south-1', '2023-12', 24817.36, 56925.12]
  ['ap-south-1', '2024-08', 26275.440000000002, 83200.56]
  ['ap-south-1', '2025-04', 27733.519999999997, 110934.08]
  ['ap-south-1', '2025-12', 29191.6, 140125.68]
*/


-- Write your SQL solution below:

WITH all_events AS (
    SELECT region, -CAST(amount AS DOUBLE) AS amt, SUBSTR(bill_date, 1, 7) AS event_date FROM cloud_costs
    UNION ALL
    SELECT region, CAST(amount AS DOUBLE) AS amt, period AS event_date FROM cost_allocs
),
monthly AS (
    SELECT region, event_date, SUM(amt) AS amt
    FROM all_events
    GROUP BY region, event_date
)
SELECT region,
       event_date,
       amt,
       SUM(amt) OVER (PARTITION BY region ORDER BY event_date ROWS UNBOUNDED PRECEDING) AS running_balance
FROM monthly
ORDER BY region, event_date
