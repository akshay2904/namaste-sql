-- ======================================================================
-- Above the Line
-- ======================================================================
-- Difficulty : Hard
-- Company    : General Assembly
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/services_hitting_cost_threshold
-- ======================================================================

/*
A cloud finance team wants to know how many of their services rack up a real monthly bill, counting a service the moment its total spend for a month reaches $100. Month by month, report the percentage of services that cross that line, ignoring billing entries that have no date.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['month', 'pct_hitting_threshold']:
  ['2022-01', 100]
  ['2022-02', 100]
  ['2022-04', 0]
  ['2026-01', 83.33333333333333]
  ['2026-10', 66.66666666666667]
*/


-- Write your SQL solution below:

WITH monthly_svc AS (
    SELECT svc_name, strftime('%Y-%m', bill_date) AS month, SUM(amount) AS total_spend
    FROM cloud_costs
    WHERE bill_date IS NOT NULL
    GROUP BY svc_name, strftime('%Y-%m', bill_date)
)
SELECT month, CAST(SUM(CASE WHEN total_spend >= 100 THEN 1 ELSE 0 END) AS DOUBLE) * 100.0 / COUNT(*) AS pct_hitting_threshold
FROM monthly_svc
GROUP BY month
ORDER BY month
