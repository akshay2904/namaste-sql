-- ======================================================================
-- In the Shadow of the Peak
-- ======================================================================
-- Difficulty : Medium
-- Company    : Instacart
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/runner_up_cost_without_order_by
-- ======================================================================

/*
The FinOps team already knows each provider's single most expensive line item and now wants the next cost sitting just below it. Return that runner-up amount for every cloud provider, biggest runner-up first.

Table: cloud_costs(cost_id, provider, svc_name, region, amount, acct_id, bill_date)

Sample data - cloud_costs ['cost_id', 'provider', 'svc_name', 'region', 'amount', 'acct_id', 'bill_date']:
  [543, 'GCP', 'S3', 'us-west-2', 19.33, 'acct-1001', '2026-02-01']
  [586, 'Azure', 'RDS', 'eu-west-1', 37.16, 'acct-1002', '2026-03-01']
  [629, 'aws', 'Lambda', 'ap-southeast-1', 54.99, 'acct-1003', '2026-04-01']
  [672, 'gcp', 'BigQuery', 'us-central1', 72.82, 'acct-1004', '2026-05-01']
  [715, 'AWS', 'Cloud Run', 'europe-west1', 90.65, 'acct-1005', '2026-06-01']

Expected output ['provider', 'second_highest']:
  ['aws', 1748.84]
  ['gcp', 1713.18]
  ['azure', 1641.86]
*/


-- Write your SQL solution below:

SELECT LOWER(provider) AS provider,
       MAX(amount) AS second_highest
FROM cloud_costs c
WHERE amount < (
    SELECT MAX(amount)
    FROM cloud_costs c2
    WHERE LOWER(c2.provider) = LOWER(c.provider)
)
GROUP BY LOWER(provider)
ORDER BY second_highest DESC
