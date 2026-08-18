-- ======================================================================
-- Bronze Medal
-- ======================================================================
-- Difficulty : Easy
-- Company    : Calix
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/bronze_medal
-- ======================================================================

/*
The FinOps team is mapping the top spending tiers across cloud usage, where repeated amounts collapse into a single tier. Return the three highest cost amounts, largest first.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['amount']:
  [1784.5]
  [1766.67]
  [1748.84]
*/


-- Write your SQL solution below:

SELECT DISTINCT amount
FROM (
    SELECT
        amount,
        DENSE_RANK() OVER (ORDER BY amount DESC) AS tier
    FROM cloud_costs
) ranked
WHERE tier <= 3
ORDER BY amount DESC
