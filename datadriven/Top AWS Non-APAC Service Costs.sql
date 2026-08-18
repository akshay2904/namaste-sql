-- ======================================================================
-- Top AWS Non-APAC Service Costs
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_aws_non_apac_service_costs
-- ======================================================================

/*
Among AWS cloud costs, find the highest cost for each service that never appears in Asia-Pacific regions, with a minimum average cost of 90 across all its entries. Show each service and its max amount.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['svc_name', 'max_amount']:
  ['CloudFront', 1748.84]
  ['EC2', 1784.5]
*/


-- Write your SQL solution below:

SELECT svc_name, MAX(amount) AS max_amount
FROM cloud_costs
WHERE LOWER(provider) = 'aws'
  AND svc_name NOT IN (
    SELECT DISTINCT svc_name
    FROM cloud_costs
    WHERE LOWER(provider) = 'aws'
      AND (region LIKE '%ap-%' OR region LIKE 'ap-%')
  )
GROUP BY svc_name
HAVING AVG(amount) >= 90
