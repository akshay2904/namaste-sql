-- ======================================================================
-- What Set It Off
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/merge_triggered_builds
-- ======================================================================

/*
A CI platform's reliability team wants to see how build activity breaks down by what kicked each build off. For each trigger type, show how many builds it produced and the average build duration in seconds, listed alphabetically by trigger.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['trigger', 'build_count', 'avg_duration']:
  ['manual', 34, 454.5882352941176]
  ['pull_request', 34, 416.5882352941176]
  ['push', 32, None]
  ['schedule', 34, 435.5882352941176]
  ['webhook', 32, 458.75]
*/


-- Write your SQL solution below:

SELECT
  trigger,
  COUNT(*) AS build_count,
  AVG(dur_secs) AS avg_duration
FROM ci_builds
GROUP BY trigger
ORDER BY trigger;
