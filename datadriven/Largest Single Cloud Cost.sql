-- ======================================================================
-- Largest Single Cloud Cost
-- ======================================================================
-- Difficulty : Medium
-- Company    : Siemens
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/largest_single_cloud_cost
-- ======================================================================

/*
What is the single largest cloud cost entry in the table? Show the service name and the amount.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['svc_name', 'amount']:
  ['EC2', 1784.5]
*/


-- Write your SQL solution below:

SELECT svc_name, amount
FROM cloud_costs
ORDER BY amount DESC, svc_name ASC
LIMIT 1
