-- ======================================================================
-- Cost Density Extremes
-- ======================================================================
-- Difficulty : Medium
-- Company    : Deloitte
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cost_density_extremes
-- ======================================================================

/*
Cost density is total cost divided by the number of services in that region, rounded to the nearest integer. Show region, provider, and density for only the minimum and maximum density regions.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['region', 'provider', 'cost_density']:
  ['us-central1', 'AWS', 7857]
  ['us-central1', 'GCP', 1767]
*/


-- Write your SQL solution below:

WITH density AS (
    SELECT
        region,
        provider,
        ROUND(SUM(amount) / COUNT(DISTINCT svc_name)) AS cost_density
    FROM cloud_costs
    GROUP BY region, provider
)
SELECT region, provider, cost_density
FROM density
WHERE cost_density = (SELECT MIN(cost_density) FROM density)
   OR cost_density = (SELECT MAX(cost_density) FROM density)
