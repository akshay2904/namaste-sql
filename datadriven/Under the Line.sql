-- ======================================================================
-- Under the Line
-- ======================================================================
-- Difficulty : Medium
-- Company    : Walmart
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/teams_below_double_average_spend
-- ======================================================================

/*
A cloud FinOps platform records cost allocations against a team and a service, with many allocations per team. Find each team's total spend and its average spend across its services, keeping only teams whose total spend is under twice the average team total. The same team sometimes appears under different letter casing, so treat those as one team and list each once, smallest total first.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['team_name', 'total_spend', 'avg_svc_spend']:
  ['legal', 100, 100]
  ['finance', 150, 150]
  ['people', 200, 200]
  ['design', 250, 250]
  ['marketing', 300, 300]
*/


-- Write your SQL solution below:

WITH svc AS (
    SELECT
        LOWER(team_name) AS team_name,
        svc_name,
        SUM(amount) AS svc_spend
    FROM cost_allocs
    GROUP BY LOWER(team_name), svc_name
),
team AS (
    SELECT
        team_name,
        SUM(svc_spend) AS total_spend,
        AVG(svc_spend) AS avg_svc_spend
    FROM svc
    GROUP BY team_name
)
SELECT
    team_name,
    total_spend,
    avg_svc_spend
FROM team
WHERE total_spend < 2 * (SELECT AVG(total_spend) FROM team)
ORDER BY total_spend, team_name
