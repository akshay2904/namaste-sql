-- ======================================================================
-- Where the Money Goes
-- ======================================================================
-- Difficulty : Hard
-- Company    : PwC
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/where-the-money-goes
-- ======================================================================

/*
Finance is auditing cloud spend, and the provider names arrive inconsistently cased across the billing exports, so the same vendor shows up under several spellings. For each provider, find the single service with the highest total cost, and show those winners with the biggest spend first.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['provider', 'top_service', 'total_spend']:
  ['gcp', 'Pub/Sub', 18418.46]
  ['aws', 'CloudFront', 17296.920000000002]
  ['azure', 'RDS', 16790.2]
*/


-- Write your SQL solution below:

WITH provider_service AS (
  SELECT LOWER(provider) AS provider,
         svc_name,
         SUM(amount) AS total_spend
  FROM cloud_costs
  GROUP BY LOWER(provider), svc_name
),
ranked AS (
  SELECT provider,
         svc_name,
         total_spend,
         ROW_NUMBER() OVER (PARTITION BY provider ORDER BY total_spend DESC, svc_name) AS rn
  FROM provider_service
)
SELECT provider,
       svc_name AS top_service,
       total_spend
FROM ranked
WHERE rn = 1
ORDER BY total_spend DESC
