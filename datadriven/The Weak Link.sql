-- ======================================================================
-- The Weak Link
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/failure_rate
-- ======================================================================

/*
The platform team is reviewing CI reliability and wants to know which repositories break the most. For each repository, give the share of its builds that ended in a 'failed' status, worst first.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['repo_name', 'failure_pct']:
  ['frontend', 25]
  ['backend-api', 23.53]
  ['data-platform', 18.75]
  ['infra', 17.65]
  ['ml-pipeline', 17.65]
*/


-- Write your SQL solution below:

SELECT repo_name,
       ROUND(100.0 * SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_pct
FROM ci_builds
GROUP BY repo_name
ORDER BY failure_pct DESC, repo_name
