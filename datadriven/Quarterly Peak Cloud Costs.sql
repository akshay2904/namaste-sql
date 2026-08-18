-- ======================================================================
-- Quarterly Peak Cloud Costs
-- ======================================================================
-- Difficulty : Hard
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/quarterly_peak_cloud_costs
-- ======================================================================

/*
For a quarterly cost review, show each cloud service's highest monthly cost in Q1, Q2, Q3, and Q4 as separate columns. List services alphabetically.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['svc_name', 'q1_max', 'q2_max', 'q3_max', 'q4_max']:
  ['BigQuery', 1928.64, 1215.4399999999998, 964.32, 2285.24]
  ['Blob Storage', 2356.56, 1286.76, 1286.76, 2356.56]
  ['Cloud Run', 1964.3, 1251.1000000000001, 982.15, 357.04999999999995]
  ['CloudFront', 1611.4399999999998, 2071.2799999999997, 1714.68, 1035.64]
  ['Cosmos DB', 2392.2200000000003, 2035.6200000000001, 1322.4199999999998, 839.51]
*/


-- Write your SQL solution below:

WITH monthly AS (
    SELECT svc_name,
           strftime('%Y-%m', bill_date) AS bill_month,
           CAST(strftime('%m', bill_date) AS INTEGER) AS mth,
           SUM(amount) AS monthly_cost
    FROM cloud_costs
    WHERE amount IS NOT NULL
    GROUP BY svc_name, strftime('%Y-%m', bill_date)
)
SELECT svc_name,
       MAX(CASE WHEN mth BETWEEN 1  AND 3  THEN monthly_cost END) AS q1_max,
       MAX(CASE WHEN mth BETWEEN 4  AND 6  THEN monthly_cost END) AS q2_max,
       MAX(CASE WHEN mth BETWEEN 7  AND 9  THEN monthly_cost END) AS q3_max,
       MAX(CASE WHEN mth BETWEEN 10 AND 12 THEN monthly_cost END) AS q4_max
FROM monthly
GROUP BY svc_name
ORDER BY svc_name ASC
