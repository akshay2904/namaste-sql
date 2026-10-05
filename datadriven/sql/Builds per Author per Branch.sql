-- ======================================================================
-- Builds per Author per Branch
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/builds_per_author_per_branch
-- ======================================================================

/*
The release manager wants to see build volume broken down by who triggered the build and which branch it ran on. Show each trigger-branch combination with its build count, ordered alphabetically by trigger and branch, then by count descending.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['author', 'branch', 'build_count']:
  ['manual', 'develop', 6]
  ['manual', 'feature /spaces', 4]
  ['manual', 'feature/auth', 6]
  ['manual', 'fix/login-bug', 6]
  ['manual', 'hotfix/payment', 4]
*/


-- Write your SQL solution below:

SELECT trigger AS author, branch, COUNT(*) AS build_count
FROM ci_builds
GROUP BY trigger, branch
ORDER BY trigger ASC, branch ASC, build_count DESC
