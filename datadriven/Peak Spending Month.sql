-- ======================================================================
-- Peak Spending Month
-- ======================================================================
-- Difficulty : Easy
-- Company    : Lyft
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/peak_spending_month
-- ======================================================================

/*
The CFO flagged a spike in the cloud invoice and wants to know which billing month was responsible. Show the month with the highest total cloud spend alongside the total amount.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['billing_month', 'total_spend']:
  ['2026-04', 9088.97]
*/


-- Write your SQL solution below:

SELECT strftime('%Y-%m', bill_date) AS billing_month, SUM(amount) AS total_spend
FROM cloud_costs
GROUP BY billing_month
ORDER BY total_spend DESC
LIMIT 1
