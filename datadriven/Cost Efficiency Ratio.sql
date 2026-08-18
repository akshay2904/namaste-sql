-- ======================================================================
-- Cost Efficiency Ratio
-- ======================================================================
-- Difficulty : Easy
-- Company    : Forbes
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cost_efficiency_ratio
-- ======================================================================

/*
The FinOps team is evaluating per-record cost efficiency for EC2. For the 'EC2' service, what is the ratio of total spend to the number of billing records?

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['svc_name', 'amount_ratio']:
  ['EC2', 660.76]
*/


-- Write your SQL solution below:

SELECT svc_name, CAST(SUM(amount) AS REAL) / CAST(COUNT(*) AS REAL) AS amount_ratio
FROM cloud_costs
WHERE svc_name = 'EC2'
GROUP BY svc_name
