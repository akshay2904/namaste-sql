-- ======================================================================
-- Where the Money Pools
-- ======================================================================
-- Difficulty : Medium
-- Company    : Forbes
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_services_by_regional_cost
-- ======================================================================

/*
For each service in the 'us-west-2' region, show the total cloud cost, sorted from highest spend to lowest.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['svc_name', 'total_cost']:
  ['Cosmos DB', 7429.28]
  ['S3', 6573.4400000000005]
  ['Cloud Run', 5892.9]
  ['Lambda', 4609.14]
  ['Pub/Sub', 4383.08]
*/


-- Write your SQL solution below:

SELECT svc_name, SUM(amount) AS total_cost
FROM cloud_costs
WHERE region = 'us-west-2'
GROUP BY svc_name
ORDER BY total_cost DESC
