-- ======================================================================
-- The Extremes
-- ======================================================================
-- Difficulty : Hard
-- Company    : City and County of San Francisco
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_and_bottom_cloud_spenders
-- ======================================================================

/*
For an executive review, pull the top 5 highest-spending and the top 5 lowest-spending cloud services by total amount in 2025, listed from lowest total to highest. Show each service name and its total amount.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['svc_name', 'total_amount']:
  ['BigQuery', 8751.7]
  ['Pub/Sub', 9209.23]
*/


-- Write your SQL solution below:

WITH service_year AS (
  SELECT svc_name, SUM(amount) AS total_amount
  FROM cloud_costs
  WHERE bill_date >= '2025-01-01'
    AND bill_date <  '2026-01-01'
  GROUP BY svc_name
),
ranked AS (
  SELECT a.svc_name,
         a.total_amount,
         SUM(CASE WHEN b.total_amount >= a.total_amount THEN 1 ELSE 0 END) AS rank_high,
         SUM(CASE WHEN b.total_amount <= a.total_amount THEN 1 ELSE 0 END) AS rank_low
  FROM service_year a
  CROSS JOIN service_year b
  GROUP BY a.svc_name, a.total_amount
)
SELECT svc_name, total_amount
FROM ranked
WHERE rank_high <= 5 OR rank_low <= 5
ORDER BY total_amount ASC
LIMIT 10
