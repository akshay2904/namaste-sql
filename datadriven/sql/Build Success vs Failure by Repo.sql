-- ======================================================================
-- Build Success vs Failure by Repo
-- ======================================================================
-- Difficulty : Medium
-- Company    : Tesla
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/build_success_vs_failure_by_repo
-- ======================================================================

/*
The engineering lead needs a per-repo build health snapshot before freezing deploys. For each repository, show how many builds have a status of 'success', how many have a status of 'failure', and the average build duration, ordered alphabetically by repo.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['repo_name', 'success_count', 'failure_count', 'avg_duration']:
  ['backend-api', 6, 0, 416.5882352941176]
  ['data-platform', 8, 0, 458.75]
  ['frontend', 6, 0, None]
  ['infra', 6, 0, 435.5882352941176]
  ['mobile-app', 8, 0, 473.5882352941176]
*/


-- Write your SQL solution below:

SELECT repo_name,
       SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) AS success_count,
       SUM(CASE WHEN status = 'failure' THEN 1 ELSE 0 END) AS failure_count,
       AVG(dur_secs) AS avg_duration
FROM ci_builds
GROUP BY repo_name
ORDER BY repo_name;
