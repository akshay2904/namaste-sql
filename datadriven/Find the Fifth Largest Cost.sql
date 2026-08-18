-- ======================================================================
-- Find the Fifth Largest Cost
-- ======================================================================
-- Difficulty : Medium
-- Company    : Asana
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/find_the_fifth_largest_cost
-- ======================================================================

/*
The FinOps team is investigating spending tiers and needs to isolate the fifth-highest cloud cost amount. If multiple line items share that amount, include all of them.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [4628, 'GCP', 'Blob Storage', 'us-east-1', 1713.18, 'acct-1016', '2026-01-01']
  [10004896, 'GCP', 'Blob Storage', 'us-east-1', 1713.18, 'acct-1016', '2022-12-01']
*/


-- Write your SQL solution below:

SELECT cost_id, provider, svc_name, region, amount, acct_id, bill_date
FROM cloud_costs
WHERE amount = (
  SELECT DISTINCT c1.amount
  FROM cloud_costs c1
  WHERE 4 = (SELECT COUNT(DISTINCT c2.amount) FROM cloud_costs c2 WHERE c2.amount > c1.amount)
)
ORDER BY cost_id
