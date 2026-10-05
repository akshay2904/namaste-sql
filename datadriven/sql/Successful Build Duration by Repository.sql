-- ======================================================================
-- Successful Build Duration by Repository
-- ======================================================================
-- Difficulty : Medium
-- Company    : Asana
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/successful_build_duration_by_repository
-- ======================================================================

/*
For each repository, sum the total duration of successful builds in January 2026. Repositories with no successful builds should still appear with a total of zero. Return the repository name and total duration in seconds.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['repo_name', 'total_dur_secs']:
  ['backend-api', 1220]
  ['data-platform', 0]
  ['frontend', 0]
  ['infra', 0]
  ['ml-pipeline', 0]
*/


-- Write your SQL solution below:

SELECT repos.repo_name, COALESCE(SUM(cb.dur_secs), 0) AS total_dur_secs
FROM (SELECT DISTINCT repo_name FROM ci_builds) repos
LEFT
JOIN ci_builds cb ON repos.repo_name = cb.repo_name AND cb.status = 'success' AND cb.built_at BETWEEN '2026-01-01' AND '2026-01-31'
GROUP BY repos.repo_name
