-- ======================================================================
-- Top Cost Entry per Team
-- ======================================================================
-- Difficulty : Medium
-- Company    : Visa
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_cost_entry_per_team
-- ======================================================================

/*
For each team in the cost allocation table, surface the highest-cost entry showing the team name, a label combining service name and region, and the amount.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['team_name', 'entry_label', 'amount']:
  ['DATA-ENG', 'EC2 - us-west-2', 18058.74]
  ['Platform', 'SQS - us-east-1', 17967.61]
  ['backend', 'Lambda - us-central1', 17603.09]
  ['data-eng', 'RDS - ap-south-1', 18241]
  ['design', 'S3 - ap-south-1', 250]
*/


-- Write your SQL solution below:

SELECT team_name, svc_name || ' - ' || region AS entry_label, amount
FROM (
    SELECT team_name, svc_name, region, amount,
           DENSE_RANK() OVER (PARTITION BY team_name ORDER BY amount DESC) AS rnk
    FROM cost_allocs
) ranked
WHERE rnk = 1
ORDER BY team_name
