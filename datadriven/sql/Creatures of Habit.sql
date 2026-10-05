-- ======================================================================
-- Creatures of Habit
-- ======================================================================
-- Difficulty : Hard
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/mode_of_small_team_costs
-- ======================================================================

/*
We track every cloud cost allocation by team and service, and we're profiling the big teams: the ones that spread spend across more than three different services. For each of those teams, find the service it allocates most often, along with that allocation count.

Table: cost_allocs(alloc_id, team_name, svc_name, region, amount, period, acct_id, category)

Sample data - cost_allocs ['alloc_id', 'team_name', 'svc_name', 'region', 'amount', 'period', 'acct_id', 'category']:
  [129, 'data-eng', 'S3', 'us-west-2', 83.21, '2026-02', 'acct-101', 'storage']
  [158, 'ml-team', 'RDS', 'eu-west-1', 156.42, '2026-03', 'acct-102', 'network']
  [187, 'frontend', 'Lambda', 'ap-south-1', 229.63, '2026-04', 'acct-103', 'database']
  [216, 'backend', 'BigQuery', 'us-central1', 302.84, '2026-05', 'acct-104', 'ml']
  [245, 'devops', 'CloudFront', 'europe-west1', 376.05, '2026-06', 'acct-105', 'other']

Expected output ['team_name', 'svc_name', 'cnt']:
  ['DATA-ENG', 'EC2', 3]
  ['Platform', 'CloudFront', 3]
  ['backend', 'BigQuery', 3]
  ['data-eng', 'EC2', 3]
  ['mobile', 'EKS', 3]
*/


-- Write your SQL solution below:

WITH large AS (
  SELECT team_name
  FROM cost_allocs
  GROUP BY team_name
  HAVING COUNT(DISTINCT svc_name) > 3
),
svc_counts AS (
  SELECT team_name, svc_name, COUNT(*) AS cnt
  FROM cost_allocs
  WHERE team_name IN (SELECT team_name FROM large)
  GROUP BY team_name, svc_name
),
ranked AS (
  SELECT team_name, svc_name, cnt,
         ROW_NUMBER() OVER (PARTITION BY team_name ORDER BY cnt DESC, svc_name) AS rn
  FROM svc_counts
)
SELECT team_name, svc_name, cnt
FROM ranked
WHERE rn = 1
ORDER BY team_name
