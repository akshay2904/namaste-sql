-- ======================================================================
-- The Accumulator
-- ======================================================================
-- Difficulty : Hard
-- Company    : Sanofi
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/running_total_with_cte
-- ======================================================================

/*
The FinOps dashboard needs a daily cloud cost time series with a running cumulative total so stakeholders can see how spending accumulates through the billing period. Show each billing date, its daily spend, and the cumulative spend through that date.

Table: cloud_costs(cost_id, bill_date, amount)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['bill_date', 'daily_spend', 'cumulative_spend']:
  ['2022-01-01', 1108.46, 1108.46]
  ['2022-02-01', 1999.96, 3108.42]
  ['2022-03-01', 910.83, 4019.25]
  ['2022-04-01', 61.97999999999996, 4081.23]
  ['2022-05-01', 732.53, 4813.76]
*/


-- Write your SQL solution below:

WITH daily AS (
    SELECT bill_date, SUM(amount) AS daily_spend
    FROM cloud_costs
    GROUP BY bill_date
)
SELECT bill_date, daily_spend, SUM(daily_spend) OVER (ORDER BY bill_date) AS cumulative_spend
FROM daily
ORDER BY bill_date
