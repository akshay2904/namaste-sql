-- ======================================================================
-- Top Repos by Successful Builds
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_repos_by_successful_builds
-- ======================================================================

/*
The CI/CD team is identifying the repositories with the most successful builds. Show each repo and its count of successful builds, sorted from most successful to fewest.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['repo_name', 'success_count']:
  ['data-platform', 8]
  ['mobile-app', 8]
  ['backend-api', 6]
  ['frontend', 6]
  ['infra', 6]
*/


-- Write your SQL solution below:

SELECT repo_name, COUNT(*) AS success_count
FROM ci_builds
WHERE status = 'success'
GROUP BY repo_name
ORDER BY success_count DESC, repo_name ASC
