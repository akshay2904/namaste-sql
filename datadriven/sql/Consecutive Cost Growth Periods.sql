-- ======================================================================
-- Consecutive Cost Growth Periods
-- ======================================================================
-- Difficulty : Hard
-- Company    : Visa
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/consecutive_cost_growth_periods
-- ======================================================================

/*
Find periods where total cloud spending increased for 2 consecutive billing periods. Return the starting bill date of each growth streak and its length.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['start_date', 'streak_len']:
  ['2022-05-01', 3]
  ['2022-11-01', 3]
  ['2023-07-01', 2]
  ['2023-12-01', 3]
  ['2024-08-01', 2]
*/


-- Write your SQL solution below:

WITH monthly AS (
  SELECT bill_date, SUM(amount) AS total_amount FROM cloud_costs WHERE amount IS NOT NULL GROUP BY bill_date
),
with_lag AS (
  SELECT bill_date, total_amount,
    LAG(total_amount) OVER (ORDER BY bill_date) AS prev_amount,
    ROW_NUMBER() OVER (ORDER BY bill_date) AS rn
  FROM monthly
),
increasing AS (
  SELECT bill_date, rn FROM with_lag WHERE total_amount > prev_amount
),
streak_groups AS (
  SELECT bill_date, rn - ROW_NUMBER() OVER (ORDER BY bill_date) AS grp FROM increasing
)
SELECT MIN(bill_date) AS start_date, COUNT(*) AS streak_len
FROM streak_groups
GROUP BY grp
HAVING COUNT(*) >= 2
ORDER BY start_date
