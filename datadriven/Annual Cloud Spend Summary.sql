-- ======================================================================
-- Annual Cloud Spend Summary
-- ======================================================================
-- Difficulty : Easy
-- Company    : Uber
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/annual_cloud_spend_summary
-- ======================================================================

/*
The annual infrastructure review needs a slide showing how cloud spend and service sprawl have grown. For each fiscal year, report the total amount spent and how many unique services appeared on the bill.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['fiscal_year', 'total_spend', 'service_count']:
  ['2022', 15743.720000000001, 2]
  ['2023', 16482.79, 2]
  ['2024', 17221.86, 2]
  ['2025', 17960.93, 2]
  ['2026', 89733.7, 10]
*/


-- Write your SQL solution below:

SELECT strftime('%Y', bill_date) AS fiscal_year,
       SUM(amount) AS total_spend,
       COUNT(DISTINCT svc_name) AS service_count
FROM cloud_costs
GROUP BY strftime('%Y', bill_date)
ORDER BY fiscal_year;
