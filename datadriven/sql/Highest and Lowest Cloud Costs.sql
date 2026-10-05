-- ======================================================================
-- Highest and Lowest Cloud Costs
-- ======================================================================
-- Difficulty : Medium
-- Company    : Siemens
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/highest_and_lowest_cloud_costs
-- ======================================================================

/*
Find the single highest-cost and single lowest-cost entries across the entire cloud cost dataset. For each, show the cost ID, amount, service name, and a label indicating whether it is the highest or lowest.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['cost_id', 'amount', 'svc_name', 'cost_type']:
  [4800, 1784.5, 'EC2', 'Highest Cost']
  [10004900, 1784.5, 'EC2', 'Highest Cost']
  [4585, -268.5, 'Cloud Run', 'Lowest Cost']
  [10004895, -268.5, 'Cloud Run', 'Lowest Cost']
*/


-- Write your SQL solution below:

SELECT cost_id, amount, svc_name, 'Highest Cost' AS cost_type
FROM cloud_costs
WHERE amount = (SELECT MAX(amount) FROM cloud_costs)
UNION ALL
SELECT cost_id, amount, svc_name, 'Lowest Cost' AS cost_type
FROM cloud_costs
WHERE amount = (SELECT MIN(amount) FROM cloud_costs)
