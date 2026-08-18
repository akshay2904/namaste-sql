-- ======================================================================
-- The Heavy Hitters
-- ======================================================================
-- Difficulty : Medium
-- Company    : Finicity, a Mastercard
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_services_per_provider
-- ======================================================================

/*
The FinOps team needs the top 2 highest-spending services within each cloud provider. If two services tie on spend within a provider, include both.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['provider', 'svc_name', 'total_spend']:
  ['AWS', 'EC2', 13215.2]
  ['Azure', 'RDS', 16790.2]
  ['GCP', 'S3', 16433.600000000002]
  ['aws', 'CloudFront', 17296.920000000002]
  ['gcp', 'Pub/Sub', 18418.46]
*/


-- Write your SQL solution below:

SELECT provider, svc_name, total_spend
FROM (
    SELECT
        provider,
        svc_name,
        SUM(amount) AS total_spend,
        DENSE_RANK() OVER (
            PARTITION BY provider
            ORDER BY SUM(amount) DESC
        ) AS rnk
    FROM cloud_costs
    GROUP BY provider, svc_name
) ranked
WHERE rnk <= 2
ORDER BY provider, total_spend DESC
