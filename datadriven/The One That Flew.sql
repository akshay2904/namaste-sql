-- ======================================================================
-- The One That Flew
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/fastest_ci_build_date
-- ======================================================================

/*
The CI/CD team is setting a performance baseline from the fastest build ever recorded, and a build only has a duration once it actually finishes. Surface the date and duration of the shortest completed CI build on record, and if more than one build ties for the shortest, take the earliest one.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['built_at', 'min_duration']:
  ['2026-11-12 23:35:00', 20]
*/


-- Write your SQL solution below:

SELECT built_at, dur_secs AS min_duration
FROM ci_builds
WHERE dur_secs IS NOT NULL
ORDER BY dur_secs ASC, built_at ASC
LIMIT 1;
