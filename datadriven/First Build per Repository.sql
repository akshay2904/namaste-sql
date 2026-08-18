-- ======================================================================
-- First Build per Repository
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/first_build_per_repository
-- ======================================================================

/*
The CI/CD team is mapping out when each repository first started running builds. Show each repo alongside its earliest build date, ordered chronologically then alphabetically by repo name.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['repo_name', 'first_build_date']:
  ['backend-api', '2022-01-02 01:13:00']
  ['infra', '2022-02-03 14:38:00']
  ['ml-pipeline', '2022-03-24 03:03:00']
  ['mobile-app', '2022-04-17 16:28:00']
  ['data-platform', '2022-05-14 17:53:00']
*/


-- Write your SQL solution below:

SELECT repo_name, MIN(built_at) AS first_build_date FROM ci_builds GROUP BY repo_name ORDER BY first_build_date ASC, repo_name ASC
