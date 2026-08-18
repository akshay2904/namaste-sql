-- ======================================================================
-- The Weight of the Cloud
-- ======================================================================
-- Difficulty : Medium
-- Company    : Apple
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/quarterly_consolidated_cloud_costs
-- ======================================================================

/*
A finance team is closing out the cloud books quarter by quarter, counting only costs billed in 2026. Weight each service's cost by every allocation booked against that same service, then report each quarter's total weighted spend, earliest quarter first.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['quarter', 'weighted_spend']:
  ['Q1', 2742642863.1858]
  ['Q2', 2744345102.4006]
  ['Q3', 3042004120.8344]
  ['Q4', 3254394925.8096]
*/


-- Write your SQL solution below:

SELECT
    CASE
        WHEN CAST(strftime('%m', cc.bill_date) AS INTEGER) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN CAST(strftime('%m', cc.bill_date) AS INTEGER) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN CAST(strftime('%m', cc.bill_date) AS INTEGER) BETWEEN 7 AND 9 THEN 'Q3'
        ELSE 'Q4'
    END AS quarter,
    SUM(cc.amount * ca.amount) AS weighted_spend
FROM cloud_costs cc
JOIN cost_allocs ca
  ON cc.svc_name = ca.svc_name
WHERE strftime('%Y', cc.bill_date) = '2026'
GROUP BY quarter
ORDER BY quarter
