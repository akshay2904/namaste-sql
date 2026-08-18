-- ======================================================================
-- Cost Efficiency Variance
-- ======================================================================
-- Difficulty : Hard
-- Company    : Uber
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cost_efficiency_variance
-- ======================================================================

/*
For each billing entry, compute the cost-per-service ratio (amount divided by the number of services in that region). Then find the monthly average of these ratios. For each year-month, show the average ratio, the monthly average, and the average absolute difference between individual ratios and that month's average.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['ym', 'actual_ratio', 'monthly_average', 'avg_abs_difference']:
  ['2022-01', 110.846, 110.846, 106.98000000000002]
  ['2022-02', 199.99599999999998, 199.99599999999998, 106.98]
  ['2022-03', 182.166, 182.166, 0]
  ['2022-04', 6.197999999999997, 6.197999999999997, 51.158]
  ['2022-05', 146.506, 146.506, 0]
*/


-- Write your SQL solution below:

WITH svc_per_region AS (
  SELECT region, COUNT(DISTINCT svc_name) AS svc_count
  FROM cloud_costs
  GROUP BY region
),
with_ratio AS (
  SELECT cc.cost_id, cc.svc_name, cc.region, cc.amount, cc.bill_date,
         strftime('%Y-%m', cc.bill_date) AS ym,
         CAST(cc.amount AS REAL) / sr.svc_count AS cost_ratio
  FROM cloud_costs cc
  INNER JOIN svc_per_region sr ON cc.region = sr.region
),
monthly_avg AS (
  SELECT ym, AVG(cost_ratio) AS avg_ratio
  FROM with_ratio
  GROUP BY ym
),
diffs AS (
  SELECT wr.ym,
         wr.cost_ratio AS actual_ratio,
         ma.avg_ratio AS monthly_average,
         ABS(wr.cost_ratio - ma.avg_ratio) AS abs_diff
  FROM with_ratio wr
  INNER JOIN monthly_avg ma ON wr.ym = ma.ym
)
SELECT ym,
       AVG(actual_ratio) AS actual_ratio,
       AVG(monthly_average) AS monthly_average,
       AVG(abs_diff) AS avg_abs_difference
FROM diffs
GROUP BY ym
ORDER BY ym
