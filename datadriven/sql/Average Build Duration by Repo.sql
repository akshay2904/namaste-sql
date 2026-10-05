-- ======================================================================
-- Average Build Duration by Repo
-- ======================================================================
-- Difficulty : Easy
-- Company    : Delta Air Lines
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_build_duration_by_repo
-- ======================================================================

/*
Slow builds are blocking deploys and the CI/CD team suspects a few repos are dragging down the pipeline. Show the average build duration in seconds for each repository so the team can identify the worst offenders.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['repo_name', 'avg_duration']:
  ['backend-api', 416.5882352941176]
  ['data-platform', 458.75]
  ['frontend', None]
  ['infra', 435.5882352941176]
  ['ml-pipeline', 454.5882352941176]
*/


-- Write your SQL solution below:

SELECT repo_name, AVG(dur_secs) AS avg_duration
FROM ci_builds
GROUP BY repo_name
