-- ======================================================================
-- The Quiet Drain
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/expensive_aws_services
-- ======================================================================

/*
The FinOps team flags any AWS line item costing 200 or more as high-cost. Broken down by region, count how many different AWS services carry at least one high-cost entry, from the most down to the fewest.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['region', 'service_count']:
  ['eu-west-1', 2]
  ['europe-west1', 2]
  ['us-central1', 2]
  ['ap-southeast-1', 1]
  ['us-east-1', 1]
*/


-- Write your SQL solution below:

SELECT region,
       COUNT(DISTINCT svc_name) AS service_count
FROM cloud_costs
WHERE LOWER(provider) = 'aws'
  AND amount >= 200
GROUP BY region
ORDER BY service_count DESC, region
