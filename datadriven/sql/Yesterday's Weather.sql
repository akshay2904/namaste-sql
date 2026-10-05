-- ======================================================================
-- Yesterday's Weather
-- ======================================================================
-- Difficulty : Hard
-- Company    : Uber
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_cloud_cost_forecast_error
-- ======================================================================

/*
A FinOps team benchmarks its cost models against the simplest possible forecast: whatever a month actually cost becomes next month's prediction. Total each month's real cloud spend, keeping only positive charges so that credits (posted as a negative `amount`) and unpriced items (a null `amount`) never distort the figure, and treat the prior month's total as the current month's forecast. Report each month's year-month, its actual cost, the forecast, and the absolute percent error of the forecast measured against that month's actual cost.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['ym', 'actual_cost', 'forecasted_cost', 'pct_error']:
  ['2022-02', 1999.96, 1108.46, 44.57589151783036]
  ['2022-03', 910.83, 1999.96, 119.57555196908316]
  ['2022-04', 286.78, 910.83, 217.60583025315577]
  ['2022-05', 732.53, 286.78, 60.850750139926014]
  ['2022-06', 1286.76, 732.53, 43.071746090957134]
*/


-- Write your SQL solution below:

WITH monthly AS (
  SELECT strftime('%Y-%m', bill_date) AS ym, SUM(amount) AS total_amount
  FROM cloud_costs WHERE amount IS NOT NULL AND amount > 0
  GROUP BY strftime('%Y-%m', bill_date)
),
ratios AS (
  SELECT ym, total_amount, LAG(total_amount) OVER (ORDER BY ym) AS prev_amount FROM monthly
)
SELECT ym, total_amount AS actual_cost, prev_amount AS forecasted_cost,
  CASE WHEN total_amount > 0 THEN ABS((prev_amount - total_amount) / total_amount) * 100 END AS pct_error
FROM ratios
WHERE prev_amount IS NOT NULL
ORDER BY ym
