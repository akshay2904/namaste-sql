-- ======================================================================
-- Three Lowest Distinct Cloud Cost Amounts
-- ======================================================================
-- Difficulty : Easy
-- Company    : Revolut
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/three_lowest_distinct_cloud_cost_amounts
-- ======================================================================

/*
Surface the three lowest unique cloud cost amounts. If two line items share the same amount, count that as one value.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['amount']:
  [None]
  [-268.5]
  [-224.8]
*/


-- Write your SQL solution below:

SELECT DISTINCT amount
FROM cloud_costs
ORDER BY amount ASC
LIMIT 3
