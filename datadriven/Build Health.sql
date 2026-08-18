-- ======================================================================
-- Build Health
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/build_health
-- ======================================================================

/*
The platform team wants a CI health leaderboard for the all-hands, scoring each repository in `ci_builds` by its success rate. Measure that rate against every build a repo ran, not only the ones that ended in success or failure, and leave out repos with too few builds to be meaningful. Show the healthiest repos first.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['repo_name', 'success_count', 'failed_count', 'total_builds', 'success_rate']:
  ['data-platform', 8, 6, 32, 25]
  ['mobile-app', 8, 6, 34, 23.529]
  ['frontend', 6, 8, 32, 18.75]
  ['ml-pipeline', 6, 6, 34, 17.647]
  ['infra', 6, 6, 34, 17.647]
*/


-- Write your SQL solution below:

SELECT
  repo_name,
  SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) AS success_count,
  SUM(CASE WHEN status = 'failed'  THEN 1 ELSE 0 END) AS failed_count,
  COUNT(*) AS total_builds,
  ROUND(100.0 * SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) / COUNT(*), 3) AS success_rate
FROM ci_builds
GROUP BY repo_name
HAVING COUNT(*) >= 3
ORDER BY success_rate DESC
