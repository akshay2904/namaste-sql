-- ======================================================================
-- Median Cloud Cost by Service
-- ======================================================================
-- Difficulty : Hard
-- Company    : City and County of San Francisco
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/median_cloud_cost_by_service
-- ======================================================================

/*
Compute the median cloud cost amount for each service. Show each service and its median amount, from highest median to lowest.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['svc_name', 'median_amount']:
  ['Pub/Sub', 964.3199999999999]
  ['CloudFront', 946.49]
  ['BigQuery', 875.1700000000001]
  ['Lambda', 857.34]
  ['RDS', 839.51]
*/


-- Write your SQL solution below:

WITH ranked AS (
  SELECT svc_name, amount,
         ROW_NUMBER() OVER (PARTITION BY svc_name ORDER BY amount) AS rn,
         COUNT(*) OVER (PARTITION BY svc_name) AS cnt
  FROM cloud_costs
)
SELECT svc_name, AVG(amount) AS median_amount
FROM ranked
WHERE rn IN ((cnt + 1) / 2, (cnt + 2) / 2)
GROUP BY svc_name
ORDER BY median_amount DESC, svc_name ASC
