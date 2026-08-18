-- ======================================================================
-- Cloud Cost Trend Analysis
-- ======================================================================
-- Difficulty : Medium
-- Company    : Tesla
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cloud_cost_trend_analysis
-- ======================================================================

/*
FinOps wants to spot bumpy cloud bills service by service. For every individual bill, list the service, the billing date, the amount, and how much that bill moved versus the service's previous bill. The first bill on record for a service has nothing to compare against. Walk the bills service by service, oldest to newest.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['svc_name', 'bill_date', 'amount', 'price_change']:
  ['BigQuery', '2025-02-01', 251.12, None]
  ['Blob Storage', '2022-02-01', 465.08, None]
  ['Cloud Run', '2026-01-01', 447.25, None]
  ['CloudFront', '2024-02-01', -137.4, None]
  ['Cosmos DB', '2023-01-01', 661.21, None]
*/


-- Write your SQL solution below:

SELECT
    svc_name,
    bill_date,
    amount,
    amount - LAG(amount) OVER (PARTITION BY svc_name ORDER BY bill_date) AS price_change
FROM cloud_costs
ORDER BY svc_name, bill_date
