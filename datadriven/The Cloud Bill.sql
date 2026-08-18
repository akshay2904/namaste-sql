-- ======================================================================
-- The Cloud Bill
-- ======================================================================
-- Difficulty : Medium
-- Company    : Microsoft
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_spend_pivot_by_provider
-- ======================================================================

/*
The finance team is reconciling cloud invoices and wants a monthly read on spend by provider, but the provider names arrive with inconsistent casing where 'aws' and 'AWS' both mean the same platform. Give the combined total for AWS, GCP, and Azure in each month, counting every billing entry, oldest month first.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['month', 'aws_total', 'gcp_total', 'azure_total']:
  ['2022-01', 0, 1108.46, 0]
  ['2022-02', 0, 1999.96, 0]
  ['2022-03', 0, 910.83, 0]
  ['2022-04', 0, 61.97999999999996, 0]
  ['2022-05', 0, 732.53, 0]
*/


-- Write your SQL solution below:

SELECT STRFTIME('%Y-%m', bill_date) AS month,
    SUM(CASE WHEN UPPER(provider) = 'AWS' THEN amount ELSE 0 END) AS aws_total,
    SUM(CASE WHEN UPPER(provider) = 'GCP' THEN amount ELSE 0 END) AS gcp_total,
    SUM(CASE WHEN UPPER(provider) = 'AZURE' THEN amount ELSE 0 END) AS azure_total
FROM cloud_costs
GROUP BY STRFTIME('%Y-%m', bill_date)
ORDER BY month
