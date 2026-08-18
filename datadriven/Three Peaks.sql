-- ======================================================================
-- Three Peaks
-- ======================================================================
-- Difficulty : Hard
-- Company    : Twitter, Inc.
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_3_monthly_costs_per_team
-- ======================================================================

/*
For each team, surface the three highest unique monthly cost amounts, listed alphabetically by team and then by amount from highest to lowest.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['team_name', 'monthly_cost']:
  ['DATA-ENG', 27270.42]
  ['DATA-ENG', 18058.74]
  ['DATA-ENG', 17831.63]
  ['Platform', 27032.870000000003]
  ['Platform', 17967.61]
*/


-- Write your SQL solution below:

WITH monthly AS (
    SELECT team_name, period, SUM(amount) AS monthly_cost
    FROM cost_allocs
    GROUP BY team_name, period
),
distinct_costs AS (
    SELECT DISTINCT team_name, monthly_cost
    FROM monthly
),
ranked AS (
    SELECT
        team_name,
        monthly_cost,
        DENSE_RANK() OVER (
            PARTITION BY team_name
            ORDER BY monthly_cost DESC
        ) AS rnk
    FROM distinct_costs
)
SELECT team_name, monthly_cost
FROM ranked
WHERE rnk <= 3
ORDER BY team_name, monthly_cost DESC;
