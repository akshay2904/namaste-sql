-- ======================================================================
-- Bottom 2% Services by Spend
-- ======================================================================
-- Difficulty : Hard
-- Company    : British Airways
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/bottom_2_services_by_spend
-- ======================================================================

/*
FinOps is hunting for zombie services that cost almost nothing but still consume billing line items. Identify the bottom 2% of services by total cloud spend in May 2026 by bucketing them into 50 equal-sized percentile groups and returning those in the lowest bucket. Show the service name and total spend, from lowest up.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['svc_name', 'total_spend']:
  ['Blob Storage', 61.97999999999996]
*/


-- Write your SQL solution below:

WITH monthly_totals AS (
  SELECT svc_name, SUM(amount) AS total_spend
  FROM cloud_costs
  WHERE strftime('%Y', bill_date) = '2026'
    AND strftime('%m', bill_date) = '05'
  GROUP BY svc_name
),
ranked AS (
  SELECT svc_name,
         total_spend,
         NTILE(50) OVER (ORDER BY total_spend) AS percentile_bucket
  FROM monthly_totals
)
SELECT svc_name, total_spend
FROM ranked
WHERE percentile_bucket = 1
ORDER BY total_spend;
