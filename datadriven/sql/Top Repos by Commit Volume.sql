-- ======================================================================
-- Top Repos by Commit Volume
-- ======================================================================
-- Difficulty : Medium
-- Company    : Merilytics
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_repos_by_commit_volume
-- ======================================================================

/*
Our CI system tracks builds per repository. For each repo that has CI build history, count total commits and rank them. Return repos in the top 5 tiers by commit volume, where tied repos share the same rank. Show the repository name and commit count.

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['repo_name', 'commit_count']:
  ['mobile-app', 1156]
  ['ml-pipeline', 1156]
  ['infra', 1156]
  ['frontend', 1024]
  ['data-platform', 1024]
*/


-- Write your SQL solution below:

WITH repo_counts AS (
  SELECT rc.repo_name,
         COUNT(rc.commit_id) AS commit_count,
         RANK() OVER (ORDER BY COUNT(rc.commit_id) DESC) AS rnk
  FROM repo_commits rc
  INNER JOIN ci_builds cb
    ON rc.repo_name = cb.repo_name
  GROUP BY rc.repo_name
)
SELECT repo_name, commit_count
FROM repo_counts
WHERE rnk <= 5
