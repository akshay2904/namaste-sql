-- ======================================================================
-- First Light
-- ======================================================================
-- Difficulty : Medium
-- Company    : Samsara
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/early_commit_velocity_by_author
-- ======================================================================

/*
We're profiling who was shipping code in each repo's scrappy early days, before it ever logged a successful CI build. For each of those authors, report their average lines added and average lines removed per commit, biggest contributions first.

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

Expected output ['author', 'avg_lines_added', 'avg_lines_removed']:
  ['eve', 260, 114.54545454545455]
  ['charlie', 259.09090909090907, 95.45454545454545]
  ['Alice', 250, 90]
  ['alice', 249.8181818181818, 91.63636363636364]
  ['frank', 244.55555555555554, 85.66666666666667]
*/


-- Write your SQL solution below:

WITH first_success AS (
    SELECT repo_name, MIN(built_at) AS first_success_at
    FROM ci_builds
    WHERE status = 'success'
    GROUP BY repo_name
)
SELECT
    rc.author,
    AVG(rc.added) AS avg_lines_added,
    AVG(rc.removed) AS avg_lines_removed
FROM repo_commits rc
JOIN first_success fs ON rc.repo_name = fs.repo_name
WHERE rc.commit_at < fs.first_success_at
GROUP BY rc.author
ORDER BY avg_lines_added DESC
