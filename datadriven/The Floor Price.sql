-- ======================================================================
-- The Floor Price
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/minimum_cost_per_provider
-- ======================================================================

/*
Ahead of reserved-instance negotiations, the FinOps team wants to anchor their bid on the smallest real charge each cloud provider has ever billed. The amount column mixes genuine charges with credits and refunds that land as zero or negative, so consider only the actual amounts paid. Show each provider with its lowest charged amount, cheapest first.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['provider', 'min_amount']:
  ['GCP', 19.33]
  ['AZURE', 37.16]
  ['AWS', 54.99]
*/


-- Write your SQL solution below:

SELECT UPPER(provider) AS provider, MIN(amount) AS min_amount
FROM cloud_costs
WHERE amount IS NOT NULL AND amount > 0
GROUP BY UPPER(provider)
ORDER BY min_amount ASC, provider ASC
