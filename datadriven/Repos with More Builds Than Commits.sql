-- ======================================================================
-- Repos with More Builds Than Commits
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/repos_with_more_builds_than_commits
-- ======================================================================

/*
Looking at CI/CD health, find all repos where the number of builds meets or exceeds the number of commits. Show each repo with its build count, ranked from highest to lowest.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['repo_name', 'build_count']:
  ['mobile-app', 34]
  ['ml-pipeline', 34]
  ['infra', 34]
  ['frontend', 32]
  ['data-platform', 32]
*/


-- Write your SQL solution below:

SELECT cb.repo_name, COUNT(DISTINCT cb.build_id) AS build_count
FROM ci_builds cb
INNER JOIN repo_commits rc ON cb.repo_name = rc.repo_name
GROUP BY cb.repo_name
HAVING COUNT(DISTINCT cb.build_id) >= COUNT(DISTINCT rc.commit_id)
ORDER BY build_count DESC
