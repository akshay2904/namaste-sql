-- ======================================================================
-- Yesterday's Crown
-- ======================================================================
-- Difficulty : Hard
-- Company    : IBM
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/previous_day_top_service
-- ======================================================================

/*
A cost dashboard shows, for each billing day, the top-spending service from the day before, where a service's spend on a day is the total of all its charges that day. Return the billing day alongside that prior-day service and its spending total.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['bill_day', 'svc_name', 'total_amount']:
  ['2022-02-01', 'S3', 1108.46]
  ['2022-03-01', 'Blob Storage', 1999.96]
  ['2022-04-01', 'S3', 910.83]
  ['2022-05-01', 'Blob Storage', 61.98]
  ['2022-06-01', 'S3', 732.53]
*/


-- Write your SQL solution below:

WITH daily_totals AS (
  SELECT DATE(bill_date) AS bill_day,
         svc_name,
         ROUND(SUM(amount), 2) AS total_amount
  FROM cloud_costs
  GROUP BY DATE(bill_date), svc_name
),
day_grid AS (
  SELECT bill_day,
         LAG(bill_day) OVER (ORDER BY bill_day) AS prev_day
  FROM (SELECT DISTINCT bill_day FROM daily_totals)
),
ranked AS (
  SELECT dt.bill_day,
         dt.svc_name,
         dt.total_amount,
         g.prev_day,
         DENSE_RANK() OVER (PARTITION BY dt.bill_day ORDER BY dt.total_amount DESC) AS rnk
  FROM daily_totals dt
  JOIN day_grid g ON g.bill_day = dt.bill_day
)
SELECT g.bill_day AS bill_day,
       r.svc_name AS svc_name,
       r.total_amount AS total_amount
FROM day_grid g
JOIN ranked r ON r.bill_day = g.prev_day AND r.rnk = 1
WHERE g.prev_day IS NOT NULL
ORDER BY g.bill_day, r.svc_name
