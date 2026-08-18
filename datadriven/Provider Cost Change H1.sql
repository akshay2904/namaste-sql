-- ======================================================================
-- Provider Cost Change H1
-- ======================================================================
-- Difficulty : Easy
-- Company    : Goldman Sachs
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/provider_cost_change_h1
-- ======================================================================

/*
FinOps wants to know how cloud spend drifted from the start of the year to mid-year. For each provider, compare the typical January bill against the typical July bill and report how much the average moved. List the providers in order.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['provider', 'amount_change']:
  ['AWS', 0]
  ['Azure', -282.3083333333334]
  ['GCP', 0]
  ['aws', 29.716666666666697]
  ['gcp', -174.37333333333333]
*/


-- Write your SQL solution below:

WITH jan AS (
    SELECT provider, AVG(amount) AS avg_amount
    FROM cloud_costs
    WHERE strftime('%m', bill_date) = '01'
    GROUP BY provider
),
jul AS (
    SELECT provider, AVG(amount) AS avg_amount
    FROM cloud_costs
    WHERE strftime('%m', bill_date) = '07'
    GROUP BY provider
)
SELECT
    jan.provider,
    jul.avg_amount - jan.avg_amount AS amount_change
FROM jan
JOIN jul ON jan.provider = jul.provider
ORDER BY jan.provider
