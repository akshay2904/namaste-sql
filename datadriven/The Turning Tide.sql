-- ======================================================================
-- The Turning Tide
-- ======================================================================
-- Difficulty : Medium
-- Company    : Postmates
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/provider_spend_variance_between_halves
-- ======================================================================

/*
Finance is reviewing whether cloud spend climbed or fell across 2026, comparing the first half (Jan through Jun) against the second half (Jul through Dec). For each provider, show how much second-half spend rose above the first half, biggest increase first.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['provider', 'spend_difference']:
  ['GCP', 1403.079999999999]
  ['aws', 816.4400000000005]
  ['gcp', -2362.6100000000006]
  ['Azure', -2877.930000000001]
  ['AWS', -4106]
*/


-- Write your SQL solution below:

SELECT
    provider,
    SUM(CASE WHEN CAST(strftime('%m', bill_date) AS INTEGER) BETWEEN 7 AND 12 THEN amount ELSE 0 END)
    - SUM(CASE WHEN CAST(strftime('%m', bill_date) AS INTEGER) BETWEEN 1 AND 6 THEN amount ELSE 0 END) AS spend_difference
FROM cloud_costs
WHERE strftime('%Y', bill_date) = '2026'
GROUP BY provider
ORDER BY spend_difference DESC
