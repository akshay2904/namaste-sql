-- ======================================================================
-- Cheapest Cost Per Region
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cheapest_cost_per_region
-- ======================================================================

/*
The FinOps team wants to know the floor price they're paying in each region. Show the minimum cloud cost amount recorded for each region.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['region', 'min_cost']:
  ['ap-southeast-1', -181.1]
  ['eu-west-1', -137.4]
  ['europe-west1', -268.5]
  ['us-central1', -224.8]
  ['us-east-1', 108.48]
*/


-- Write your SQL solution below:

SELECT region, MIN(amount) AS min_cost
FROM cloud_costs
GROUP BY region
