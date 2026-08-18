-- ======================================================================
-- Where the Money Burns
-- ======================================================================
-- Difficulty : Medium
-- Company    : Zillow
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/above_average_cloud_spend
-- ======================================================================

/*
Find the cloud services whose average cost per billing record sits above the overall average cost across all records. Return those service names in alphabetical order.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['svc_name']:
  ['BigQuery']
  ['CloudFront']
  ['EC2']
  ['Lambda']
  ['Pub/Sub']
*/


-- Write your SQL solution below:

SELECT svc_name
FROM cloud_costs
GROUP BY svc_name
HAVING AVG(amount) > (SELECT AVG(amount) FROM cloud_costs)
ORDER BY svc_name
